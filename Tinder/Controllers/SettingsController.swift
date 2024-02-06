//
//  SettingsController.swift
//  Tinder
//
//  Created by Turan Çabuk on 5.02.2024.
//

import UIKit

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    lazy var buttonImage1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var buttonImage2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var buttonImage3 = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(buttonImage1)
        let padding: CGFloat = 16
        buttonImage1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        buttonImage1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [buttonImage2, buttonImage3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: buttonImage1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        [buttonImage1, buttonImage2, buttonImage3].forEach { (butt) in
            butt.layer.borderWidth = 1.0
            butt.layer.borderColor = UIColor.darkGray.cgColor
            butt.layer.cornerRadius = 16
            butt.clipsToBounds = true
        }
        return header
        
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationItems() 
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        return headerLabel
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
        case 2:
            cell.textField.placeholder = "Enter Profession"
        case 3:
            cell.textField.placeholder = "Enter Age"
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsCell {
            cell.textField.becomeFirstResponder()
        }
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
