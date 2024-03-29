//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Turan Çabuk on 1.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
      
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) ->()) {
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    func checkFormValidity() {
        
        let formValidity = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = formValidity
    }
    var bindableIsFormValid = Bindable<Bool>()
}
