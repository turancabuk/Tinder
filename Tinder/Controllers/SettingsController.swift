//
//  SettingsController.swift
//  Tinder
//
//  Created by Turan Çabuk on 5.02.2024.
//

import UIKit

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var buttonImage1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var buttonImage2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var buttonImage3 = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
//        button.layer.cornerRadius = 16
//        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationItems()
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.addSubview(buttonImage1)
        buttonImage1.backgroundColor = .white
        buttonImage1.anchor(
            top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(
                top: 16, left: 16, bottom: 16, right: 0))
        buttonImage1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let verticalStackView = UIStackView(arrangedSubviews: [buttonImage2, buttonImage3])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 8
        verticalStackView.backgroundColor = .white
        header.addSubview(verticalStackView)
 
        verticalStackView.anchor(
            top: header.topAnchor, leading: buttonImage1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(
                top: 16, left: 16, bottom: 16, right: 16))
        
        [buttonImage1, buttonImage2, buttonImage3].forEach { (butt) in
            butt.layer.borderWidth = 1.0
            butt.layer.borderColor = UIColor.darkGray.cgColor
            butt.layer.cornerRadius = 16
            butt.clipsToBounds = true
        }
        
        return header
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    fileprivate func setupNavigationItems() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    @objc fileprivate func handleSave() {
        
    }
    @objc fileprivate func handleLogout() {
        
    }
}
class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}
extension SettingsController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton!.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
