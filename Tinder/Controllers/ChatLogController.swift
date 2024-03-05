//
//  ChatLogController.swift
//  Tinder
//
//  Created by Turan Çabuk on 26.02.2024.
//

import UIKit
import Firebase
import LBTATools

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MatchNavBar(match: self.match)
    fileprivate let match: Match
    var currentUser: User?
    var listener: ListenerRegistration?
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    lazy var customInputView : CustomInputAccesorryView  = {
        let civ = CustomInputAccesorryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    override var inputAccessoryView: UIView? {
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    deinit {
        print("Memory being reclaimed properly CHATLOG")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
       
        fetchCurrentUser()
        fetchMessages()
        setupLayout()


        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            listener?.remove()
        }
    }
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 100))
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)

        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        self.collectionView.keyboardDismissMode = .interactive

    }
    fileprivate func fetchCurrentUser() {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(currentUser).getDocument { (snapshot, err) in
            let data = snapshot?.data() ?? [:]
            self.currentUser = User(dictionary: data)
        }
        
    }
    fileprivate func fetchMessages() {
        print("Fetching messages")
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid).order(by: "timeStamp")
        
            listener = query.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Failed to fetch messages:", err)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
    }
    fileprivate func saveToFromMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let collection = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid)
        
        let data = ["text": customInputView.textView.text ?? "", "fromId": currentUserId, "toId": match.uid, "timeStamp": Timestamp(date: Date())] as [String : Any]
        
        collection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message:", err)
                return
            }
            self.customInputView.textView.text = nil
            self.customInputView.placeHolderLabel.isHidden = false
        }
        
        let toCollection = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserId)
        toCollection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message:", err)
                return
            }
            self.customInputView.textView.text = nil
            self.customInputView.placeHolderLabel.isHidden = false
        }
    }
    fileprivate func saveToFromRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        
        let data = ["text": customInputView.textView.text ?? "", "name": match.name,
                    "profileImageUrl": match.profileImageUrl, "timeStamp": Timestamp(date: Date()),
                    "uid": match.uid] as [String : Any]
        
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").document(match.uid).setData(data) { (err) in
            
            if let err = err {
                print("Failed to save recent message:", err)
                return
            }
        }
        
        // save the other direction
        guard let currentUser = self.currentUser else { return }
        let toData = ["text": customInputView.textView.text ?? "", "name": currentUser.name ?? "","profileImageUrl": currentUser.imageUrl1 ?? "","timeStamp": Timestamp(date: Date()), "uid": currentUserId] as [String : Any]
        
        Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(currentUserId).setData(toData)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        // Estimated Size for dynamic Cells
        let estimatedSizeCell = MessageCell(frame: .init(
            x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 160, left: 0, bottom: 0, right: 0)
    }
    @objc fileprivate func handleSend() {

        saveToFromMessages()
        saveToFromRecentMessages()
    }
    @objc fileprivate func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
