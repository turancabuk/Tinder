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
    var users = [String: User]()
    var lastFetchedUser: User?
    var topCardView: CardView?
    var swipes = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout(topStackView, carDeckView, bottomControls)
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
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
        navigationController?.navigationBar.isHidden = true
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
                self.users[user.uid ?? ""] = user
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] != nil
                if isNotCurrentUser && !hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    self.fetchSwipes()
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("fetch error: ", err)
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else {return}
            self.swipes = data
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
        let detailController = DetailController()
        detailController.cardViewModel = cardViewModel
        detailController.modalPresentationStyle = .fullScreen
        present(detailController, animated: true)
    }
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = 0.5
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        let documnetData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("Failed to save swiped data: ", err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documnetData) { (err) in
                    if let err = err{
                        print("Failed to save swiped data: ", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkMatch(cardUID: cardUID)
                    }
                }
            }else{
                Firestore.firestore().collection("swipes").document(uid).setData(documnetData) { (err) in
                    if let err = err{
                        print("Failed to save swiped data: ", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkMatch(cardUID: cardUID)
                    }
                }
            }
        }
    }
    // Match Cont.
    fileprivate func checkMatch(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err{
                print("Failed to save swiped data: ", err)
                return
            }
            guard let data = snapshot?.data() else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                print("its Match!!!")
                self.presentMatchView(cardUID: cardUID)
                
                guard let cardUser = self.users[cardUID] else {return}
                let data = ["name": cardUser.name ?? "", "profileImageUrl": cardUser.imageUrl1 ?? "", "uid": cardUID, "timeStamp": Timestamp(date: Date())] as [String: Any]
                Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(data) { err in
                    if let err = err {
                        print("ERROR: ", err)
                        return
                    }
                }
                
                guard let currentUser = self.user else {return}
                let currentUserData = ["name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "", "uid": currentUser.uid ?? "", "timeStamp": Timestamp(date: Date())] as [String: Any]
                Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(currentUserData) { err in
                    if let err = err {
                        print("Error: ", err)
                    }
                }
            }
        }
    }
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        view.addSubview(matchView)
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        matchView.fillSuperview()
    }
    // MARK: Button Confs.
    @objc func handleSettings() {
        let settingsController = SettingsController()
        let navigationController = UINavigationController(rootViewController: settingsController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    @objc fileprivate func handleMessage() {
        let messageController = MessageController()
        let navController = UINavigationController(rootViewController: messageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)

    }
    @objc fileprivate func handleRefreshButton() {
        carDeckView.subviews.forEach({$0.removeFromSuperview()})
        self.fetchUsersFromFirestore()
    }
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
}
                                
