//
//  AppDelegate.swift
//  Movie
//
//  Created by Wei-Lun Su on 10/2/20.
//

import UIKit
import MovieKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    private var viewControllers: [UIViewController] {
        return MovieList.allCases.map {
            let vc = MovieListViewControlller(list: $0)
            vc.title = $0.description
            let nvc = UINavigationController(rootViewController: vc)
            return nvc
        }
    }
    
    private var tabBarController: UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

