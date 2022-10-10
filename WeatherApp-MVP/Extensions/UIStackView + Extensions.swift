//
//  UIStackView + Extensions.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 30.09.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis = .horizontal,
                     spacing: CGFloat = UIStackView.spacingUseDefault) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
