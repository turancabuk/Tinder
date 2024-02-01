//
//  RegistrationController.swift
//  Tinder
//
//  Created by Turan Çabuk on 31.01.2024.
//

import UIKit

class RegistrationController: UIViewController {

    lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    lazy var fullNameTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter Full Name"
        textfield.setup()
        return textfield
    }()
    
    lazy var emailTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter email"
        textfield.keyboardType = .emailAddress
        textfield.setup()
        return textfield
    }()
    
    lazy var passwordTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter Password"
        textfield.isSecureTextEntry = true
        textfield.setup()
        return textfield
        
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = #colorLiteral(red: 0.8118591905, green: 0.09407807142, blue: 0.3270188272, alpha: 1)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var layoutStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton, fullNameTextfield, emailTextfield, passwordTextfield, registerButton])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        
    }
    fileprivate func setupLayout() {
        
        view.addSubview(layoutStackView)
        layoutStackView.axis = .vertical
        layoutStackView.spacing = 8
        layoutStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        layoutStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(
            top: 0, left: 50, bottom: 0, right: 50))
        
        view.addSubview(loginButton)
        loginButton.anchor(
            top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(
                top: 0, left: 16, bottom: 32, right: 16))
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
    fileprivate func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
            
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - layoutStackView.frame.origin.y - layoutStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    fileprivate func setupTapGesture() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    @objc fileprivate func handleDismissKeyboard() {
        
        view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }
    }
    @objc func handleLogin() {
        
    }
}
