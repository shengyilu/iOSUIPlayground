//
//  AppDelegate.swift
//  PopTipTest
//
//  Created by 盧聖宜 on 2018/9/21.
//  Copyright © 2018年 Edward. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        let feedNavCtrl = UINavigationController(rootViewController: ViewController())
        window.rootViewController  = feedNavCtrl
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    
}

