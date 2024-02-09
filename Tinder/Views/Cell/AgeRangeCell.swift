//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by Turan Çabuk on 9.02.2024.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.value = 20
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isUserInteractionEnabled = true
        slider.isEnabled = true
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.value = 25
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isUserInteractionEnabled = true
        slider.isEnabled = true
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "min: "
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "max: "
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let sliderStackView = UIStackView(arrangedSubviews: [
        UIStackView(arrangedSubviews: [minLabel, minSlider]), UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
        sliderStackView.axis = .vertical
        sliderStackView.spacing = 24
        addSubview(sliderStackView)
        sliderStackView.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(
                top: 6, left: 20, bottom: 6, right: 20))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
