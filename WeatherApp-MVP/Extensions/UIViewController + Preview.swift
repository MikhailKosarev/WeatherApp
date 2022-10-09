//
//  UIViewController+Preview.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 27.09.2022.
//

import SwiftUI

extension UIViewController {
    // for the preview
    private struct Preview: UIViewControllerRepresentable {

        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
    
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
