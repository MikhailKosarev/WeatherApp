//
//  UIAlertController + Extensions.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 05.10.2022.
//

import UIKit

extension UIAlertController {
    static func alertOk(title: String, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
}
