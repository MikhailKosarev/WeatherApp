//
//  UILabel + Extensions.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 30.09.2022.
//

import UIKit

extension UILabel {
    static func makeDetailWeatherCellTitleLabel(text: String = "Temperature max") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .label
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }
    
    static func makeDetailWeatherCellValueLabel(text: String = "14°C") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .label
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }
    
    static func makeWeatherInfoLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = .label
        label.textAlignment = .center
        return label
    }
}
