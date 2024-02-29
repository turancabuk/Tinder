//
//  MatchesHorizontalController.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.02.2024.
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
