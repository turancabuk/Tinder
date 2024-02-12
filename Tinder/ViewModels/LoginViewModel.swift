//
//  LoginViewModel.swift
//  Tinder
//
//  Created by Turan Çabuk on 12.02.2024.
//

import UIKit
import Firebase

class LoginViewModel {
    
    var isLogginIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()

    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
            isFormValid.value = isValid
    }
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {return}
        isLogginIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
}
