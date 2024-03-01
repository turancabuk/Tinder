//
//  MessageController.swift
//  Tinder
//
//  Created by Turan Çabuk on 21.02.2024.
//

import UIKit
import LBTATools
import Firebase


struct RecentMessage {
    let profileImageUrl, name, text, uid: String
    let timeStamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "USER NAME", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "2. Sektörde sarı bayraklar var ve Sebastian Vettel bariyerlerde", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override var item: RecentMessage!{
        didSet{
            userNameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    override func setupViews() {
        
        userProfileImageView.layer.cornerRadius = 90 / 2
        
        hstack(userProfileImageView.withWidth(90).withHeight(90), stack(userNameLabel, messageTextLabel, spacing: 4), spacing: 20, alignment: .center).padLeft(20).padRight(10)
        
        addSeparatorView(leadingAnchor: userNameLabel.leadingAnchor)
    }
}
class MessageController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MessageCustomNavBar()
    var recentMessagesDictionary = [String: RecentMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        items = [
//            .init(profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-e1945.appspot.com/o/images%2F994D86B1-0508-4377-9275-3E4E8C05033D?alt=media&token=60c757aa-6262-478e-818b-9e7341d569e6", name: "Christensen", text: "Nerdesin?", uid: "Random", timeStamp: Timestamp(date: Date())),
//            .init(profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-e1945.appspot.com/o/images%2FF93669BE-B453-4D6C-88B8-7004A4132217?alt=media&token=1cd0236a-c355-4e17-ae8f-7eaae4a0fa7b", name: "Veronice", text: "Hey Turan!", uid: "Random", timeStamp: Timestamp(date: Date())),
//            .init(profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-e1945.appspot.com/o/images%2FF7217604-1047-4B54-9B0F-2062F72CF40B?alt=media&token=96535084-d6bb-4e14-9d26-0fae0b81b327", name: "Kareem", text: "Abi nerdesin?", uid: "Random", timeStamp: Timestamp(date: Date()))
        ]
        
        setupLayout()
        fetchRecentMessages()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        
    }
    fileprivate func setupLayout() {
        
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
        navigationController?.navigationBar.isHidden = true
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
    }
    fileprivate func fetchRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").addSnapshotListener { (querySnapshot, err) in
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    let dictionary = change.document.data()
                    let recentMessage = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            })
            self.resetItems()
        }
    }
    fileprivate func resetItems() {
        var values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: {(recentMessage1, recentMessage2) -> Bool in
            return recentMessage1.timeStamp.compare(recentMessage2.timeStamp) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
     
    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 410)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 0, left: 12, bottom: 0, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc fileprivate func handleBackButton() {
        dismiss(animated: true)
    }
}
