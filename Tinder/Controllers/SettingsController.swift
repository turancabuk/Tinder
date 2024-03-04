//
//  SettingsController.swift
//  Tinder
//
//  Created by Turan Çabuk on 5.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD
import SDWebImage

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    class CustomImagePickerController: UIImagePickerController {
        var imageButton: UIButton?
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
    var user: User?
    
    deinit {
        print("Memory being reclaimed properly***")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationItems()
        fetchCurrentUser()


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
        
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
    fileprivate func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                DispatchQueue.main.async {
                    self.buttonImage1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                DispatchQueue.main.async {
                    self.buttonImage2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                DispatchQueue.main.async {
                    self.buttonImage3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }
    // MARK: Tableview Confs.
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
        case 4:
            headerLabel.text = "Bio"
        default :
            headerLabel.text = "Age Range"
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
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
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
    // MARK: Selectors
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
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profile saving..."
        hud.show(in: self.view)
        
        guard let document = Auth.auth().currentUser?.uid else {return}
        let documentData: [String: Any] = [
            "uid": document,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? "",
            "profession": user?.profession ?? ""
        ]
        Firestore.firestore().collection("users").document(document).setData(documentData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Save error: ", err)
                return
            }
            print("Finished saving user info")
        }
        self.dismiss(animated: true)
    }
    @objc fileprivate func handleLogout() {

        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    @objc fileprivate func handleNameChange(textfield: UITextField) {
        self.user?.name = textfield.text
    }
    @objc fileprivate func handleProfessionChange(textfield: UITextField) {
        self.user?.profession = textfield.text
    }
    @objc fileprivate func handleAgeChange(textfield: UITextField) {
        self.user?.age = Int(textfield.text ?? "")
    }
}
extension SettingsController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton!.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        picker.dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData) { (nil, err) in
            if let err = err {
                hud.dismiss()
                print("Failed to upload image to storage:", err)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL(completion: { (url, err) in
                
                hud.dismiss()
                
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("Finished getting download url:", url?.absoluteString ?? "")
                
                if imageButton == self.buttonImage1 {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.buttonImage2 {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
