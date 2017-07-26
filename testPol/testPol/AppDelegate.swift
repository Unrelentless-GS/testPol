//
//  AppDelegate.swift
//  testPol
//
//  Created by Pavel Boryseiko on 26/7/17.
//  Copyright © 2017 GRIDSTONE. All rights reserved.
//

import UIKit
import MPOLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        MPOLKitInitialize()

        let window = UIWindow()
        self.window = window

        let searchViewController = SearchViewController(viewModel: TestViewModel())

        let searchNavController = UINavigationController(rootViewController: searchViewController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNavController]

        self.tabBarController = tabBarController
        self.window?.rootViewController = tabBarController

        return true
    }
}

