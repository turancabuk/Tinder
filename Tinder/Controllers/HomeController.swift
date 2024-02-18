//
//  HomeController.swift
//  Tinder
//
//  Created by Turan Çabuk on 27.01.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController, LoginControllerDelegate, CardViewDelegate {
    
    
    let topStackView = TopNavigationStackView()
    let carDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
     
    var cardViewModels = [CardViewModel]()
    var user: User?
    var lastFetchedUser: User?
    var topCardView: CardView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout(topStackView, carDeckView, bottomControls)
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
        fetchCurrentUser()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            carDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    fileprivate func setupLayout(_ topStackView: TopNavigationStackView, _ blueView: UIView, _ buttonsStackView: HomeBottomControlsStackView) {
        let overAllStackView = UIStackView(arrangedSubviews: [
            topStackView, blueView, buttonsStackView
        ])
        overAllStackView.axis = .vertical
        view.addSubview(overAllStackView)
        view.backgroundColor = .white
        overAllStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overAllStackView.bringSubviewToFront(carDeckView)
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
        }
    }
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
                
        // querry filtering with "where"
        let query = Firestore.firestore().collection("users")
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            var previousCardView: CardView?
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        carDeckView.addSubview(cardView)
        carDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    func didTapInfoButton(cardViewModel: CardViewModel) {
        print("Home Controller: ", cardViewModel.attributedString)
        let detailController = DetailController()
        detailController.cardViewModel = cardViewModel        
        detailController.modalPresentationStyle = .fullScreen
        present(detailController, animated: true)
    }
    // MARK: Button Confs.
    @objc func handleSettings() {
        
        let settingsController = SettingsController()
        let navigationController = UINavigationController(rootViewController: settingsController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    @objc fileprivate func handleRefreshButton() {
        
        self.fetchUsersFromFirestore()
    }
    @objc fileprivate func handleLike() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            self.topCardView?.frame = CGRect(x: 600, y: 0, width: self.topCardView!.frame.width, height: self.topCardView!.frame.height)
            let angle = 15 * CGFloat.pi / 180
            self.topCardView?.transform = CGAffineTransform(rotationAngle: angle)
            
        }) { (_) in
            self.topCardView?.removeFromSuperview()
            self.topCardView = self.topCardView?.nextCardView
        }
    }
}

