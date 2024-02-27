//
//  MessageController.swift
//  Tinder
//
//  Created by Turan Çabuk on 21.02.2024.
//

import UIKit
import LBTATools
import Firebase

struct Match {
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFit)
    let userNameLabel = UILabel(text: "User Name Here", font: .systemFont(ofSize: 14, weight: .semibold))
    
    override var item: Match! {
        didSet {
            userNameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        
        profileImageView.clipsToBounds = true 
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.contentMode = .scaleAspectFill
        userNameLabel.textAlignment = .center
        stack(stack(profileImageView, alignment: .center), userNameLabel)
    }
}

class MessageController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MessageCustomNavBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupLayout()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        fetchMessages()
    }
    fileprivate func setupLayout() {
        
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
        navigationController?.navigationBar.isHidden = true
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 160, left: 12, bottom: 0, right: 12)
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
