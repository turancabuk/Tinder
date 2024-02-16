//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by Turan Çabuk on 14.02.2024.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageNames.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
        }
    }
    
    var controllers = [UIViewController]()
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        
        setupBarStackView()
        
    }
    fileprivate func setupBarStackView() {
        cardViewModel.imageNames.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
            barView.layer.cornerRadius = 4
            barStackView.addArrangedSubview(barView)
        }
        view.addSubview(barStackView)
        barStackView.spacing = 4
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.distribution = .fillEqually
        barStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(
                top: 6, left: 12, bottom: 0, right: 12), size: .init(
                    width: 0, height: 6))
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentController}) {
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = UIColor(white: 0, alpha: 0.1)})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}
