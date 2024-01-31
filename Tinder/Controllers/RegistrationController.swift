//
//  RegistrationController.swift
//  Tinder
//
//  Created by Turan Çabuk on 31.01.2024.
//

import UIKit

class RegistrationController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    let fullNameTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter Full Name"
        textfield.setup()
        return textfield
    }()
    
    let emailTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter email"
        textfield.keyboardType = .emailAddress
        textfield.setup()
        return textfield
    }()
    
    let passwordTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter Password"
        textfield.isSecureTextEntry = true
        textfield.setup()
        return textfield
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientLayer()
        setLayout()
    }
    fileprivate func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton, fullNameTextfield, emailTextfield, passwordTextfield])
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(
            top: 0, left: 50, bottom: 0, right: 50))
    }
    fileprivate func setGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9815869927, green: 0.3566627502, blue: 0.3759607673, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8924006224, green: 0.117617093, blue: 0.4611734748, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}
