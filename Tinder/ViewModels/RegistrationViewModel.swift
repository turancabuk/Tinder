//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Turan Çabuk on 1.02.2024.
//

import UIKit

class RegistrationViewModel {
    

    var image: UIImage? {didSet{imageSelectorObserver?(image)}}
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func checkFormValidity() {
        
        let formValidity = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(formValidity)
    }
    
    var isFormValidObserver: ((Bool) -> ())?
    var imageSelectorObserver: ((UIImage?) -> ())?
}
