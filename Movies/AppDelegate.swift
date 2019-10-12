//
//  AppDelegate.swift
//  Movies
//
//  Created by Jonathan Martins on 18/09/18.
//  Copyright © 2018 Jonathan Martins. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// The CoreData wrapper container
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeNavBarAppearance()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    /// Global configuration for the NavigationBar
    private func customizeNavBarAppearance(){
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        
        navigationBarAppearance.tintColor    = .white
        navigationBarAppearance.barTintColor = .appColor(.primaryColor)
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
    
        barButtonItemAppearance.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor:UIColor.white
            ], for: .normal
        )
        
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
    }
}
