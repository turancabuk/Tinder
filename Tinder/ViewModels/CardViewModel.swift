//
//  CardViewModel.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.01.2024.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}
struct CardViewModel {

    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}
