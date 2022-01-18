//
//  AppDelegate.swift
//  EssentialApp
//
//  Created by Pankaj Mangotra on 27/12/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

        configuration.delegateClass = DebuggingSceneDelegate.self
        return configuration
    }
    /*
     func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
         // Called when a new scene session is being created.
         // Use this method to select a configuration to create the new scene with.
         let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

         #if DEBUG
             configuration.delegateClass = DebuggingSceneDelegate.self
         #endif
         return configuration
     }*/
}
