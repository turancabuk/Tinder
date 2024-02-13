//
//  LoginController.swift
//  Tinder
//
//  Created by Turan Çabuk on 12.02.2024.
//

import UIKit
import Firebase
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}
class LoginController: UIViewController {
    
    let emailTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter email"
        textfield.setup()
        textfield.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textfield
    }()
    
    let passwordTextfield: CustomTextField = {
        let textfield = CustomTextField(pading: 16)
        textfield.placeholder = "Enter password"
        textfield.isSecureTextEntry = true
        textfield.setup()
        textfield.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textfield
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .lightGray
        button.backgroundColor = #colorLiteral(red: 0.8924006224, green: 0.117617093, blue: 0.4611734748, alpha: 1)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let backLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("go to Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8924006224, green: 0.117617093, blue: 0.4611734748, alpha: 1)
        button.addTarget(self, action: #selector(handleBacktoRegister), for: .touchUpInside)
        return button
    }()

    var delegate: LoginControllerDelegate?
    lazy var stackView = UIStackView(arrangedSubviews: [emailTextfield, passwordTextfield, loginButton])
    fileprivate let loginViewModel = LoginViewModel()
    let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setGradientLayer()
        setupLayout()
        setupTapGesture()
        setupBindables()
        
    }
    // MARK: Layout Confs:
    fileprivate func setGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9815869927, green: 0.3566627502, blue: 0.3759607673, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8924006224, green: 0.117617093, blue: 0.4611734748, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    fileprivate func setupLayout() {
        
        view.addSubview(self.stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.anchor(
            top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(
                top: 0, left: 20, bottom: 0, right: 20))
        view.addSubview(backLoginButton)
        backLoginButton.anchor(
            top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(
                top: 0, left: 16, bottom: 32, right: 16))
    }
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else {return}
            self.loginButton.isEnabled = isFormValid
            loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
    }
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    // MARK: Button Confs:
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextfield {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    @objc fileprivate func handleLogin() {
        
        hud.textLabel.text = "Logging..."
        hud.show(in: view)
        loginViewModel.performLogin { (err) in
            if let err = err {
                print("Login Error")
                self.hud.textLabel.text = "\(err.localizedDescription)"
                self.hud.dismiss(afterDelay: 2.5)
                return
            }else{
                self.hud.dismiss()
                let homeController = HomeController()
                homeController.modalPresentationStyle = .fullScreen
                self.present(homeController, animated: true)
            }
        }
    }
    @objc fileprivate func handleBacktoRegister() {
        
        let registerController = RegistrationController()
        registerController.modalPresentationStyle = .fullScreen
        present(registerController, animated: true)
    }
    @objc fileprivate func handleDismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }
    }
}
