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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupViewControllers()
        return true
    }
    
    private func setupViewControllers() {
        let tabBarController = UITabBarController()
        
        let viewControllers = MovieRepository.Endpoint.allCases.map { e -> UIViewController in
            let movieListController = MovieListViewControlller(endpoint: e)
            movieListController.title = e.description
            return UINavigationController(rootViewController: movieListController)
        }
        
        tabBarController.setViewControllers(viewControllers, animated: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

