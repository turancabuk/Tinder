//
//  CurrentUser.swift
//  Tinder
//
//  Created by Turan Çabuk on 11.02.2024.
//

import UIKit
import Firebase
import FirebaseFirestore



 func fetchCurrentUser() {
    
    var user: User

    guard let uid = Auth.auth().currentUser?.uid else { return }
    Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
        if let err = err {
            print(err)
            return
        }
        guard let dictionary = snapshot?.data() else { return }
        user = User(dictionary: dictionary)
        
    }
}
