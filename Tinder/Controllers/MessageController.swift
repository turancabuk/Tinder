//
//  MessageController.swift
//  Tinder
//
//  Created by Turan Çabuk on 21.02.2024.
//

import UIKit
import LBTATools
import Firebase


class MatchesHorizontalController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    var rootMatchesController: MessageController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        fetchMessages()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = self.items[indexPath.item]
        rootMatchesController?.didSelectMatchFromHeader(match: selectedItem)
    }
    fileprivate func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(uid).collection("matches").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error: ", err)
                return
            }
            
            var matches = [Match]()
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            self.items = matches
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
class MatchesHeader: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    let matchesHorizontalController = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        stack(stack(newMatchesLabel).padLeft(20), matchesHorizontalController.view, stack(messagesLabel).padLeft(20),
              spacing: 10).withMargins(.init(
            top: 160, left: 0, bottom: 20, right: 0))
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class MessageController: LBTAListHeaderController<MatchCell, Match, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MessageCustomNavBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLayout()
        fetchMessages()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        
    }
    fileprivate func setupLayout() {
        
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
        navigationController?.navigationBar.isHidden = true
        
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
            top: 20, left: 12, bottom: 0, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 120)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        let chatLogController = ChatLogController(match: selectedItem)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    fileprivate func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(uid).collection("matches").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error: ", err)
                return
            }
            
            var matches = [Match]()
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            self.items = matches
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @objc fileprivate func handleBackButton() {
        dismiss(animated: true)
    }
}
