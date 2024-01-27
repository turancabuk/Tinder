//
//  ViewController.swift
//  Tinder
//
//  Created by Turan Çabuk on 27.01.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let grayView = UIView()
//        grayView.backgroundColor = .gray

        let subview = [UIColor.gray, UIColor.darkGray, UIColor.black].map { (color) -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        let topStackView = UIStackView(arrangedSubviews: subview)
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let yellowView = UIView()
//        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
        topStackView, blueView, yellowView
        ])
        
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.frame = .init(x: 0, y: 0, width: 300, height: 200)
        stackView.fillSuperview()
    }
}

