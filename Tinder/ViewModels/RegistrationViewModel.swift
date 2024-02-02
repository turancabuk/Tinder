//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Turan Çabuk on 1.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = self.email, let password = self.password else {return}
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
            if let err = err {
                completion(err)
                return
            }
            
            let fileName = UUID().uuidString 
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            ref.putData(imageData, metadata: nil) { (_, err) in
                
                if let err = err {
                    completion(err)
                    return
                }else{
                    print("Finished uploading image to storage")
                }
            }
        }
    }
    func checkFormValidity() {
        
        let formValidity = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = formValidity
    }
    
    var bindableIsFormValid = Bindable<Bool>()
}
