//
//  MainTabBarModule.swift
//  WeatherApp-MVP
//
//  Created by Mikhail on 01.10.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Private properties
    let currentWeatherViewController: UIViewController = {
        let viewController = ModuleBulder.createCurrentWeatherModule()
        let currentImage = UIImage(systemName: Constants.currentImageSystemName)
        viewController.tabBarItem = UITabBarItem(title: "Current",
                                                 image: currentImage,
                                                 tag: 0)
        viewController.tabBarItem.badgeColor = .purple
        return viewController
    }()
    
    let fiveDayWeatherViewController: UIViewController = {
        let viewController = ModuleBulder.createFiveDayWeatherModule()
        let fiveDayImage = UIImage(systemName: Constants.fiveDaySystemName)
        viewController.tabBarItem = UITabBarItem(title: "5 day",
                                                 image: fiveDayImage,
                                                 tag: 1)
        viewController.tabBarItem.badgeColor = .purple
        return viewController
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarAppearance()
    }
    
    // MARK: - Private methods
    private func setupTabBar() {
        setViewControllers([currentWeatherViewController,
                           fiveDayWeatherViewController],
                           animated: true)
    }
    
    private func setupTabBarAppearance() {
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        
        if #available(iOS 15, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
        }
        
        tabBar.tintAdjustmentMode = .normal
        tabBar.backgroundColor = .purple
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .yellow
    }
}


#if DEBUG
import SwiftUI

struct MainTabBarController_Preview: PreviewProvider {
    static var previews: some View {
        MainTabBarController().showPreview()
    }
}
#endif
