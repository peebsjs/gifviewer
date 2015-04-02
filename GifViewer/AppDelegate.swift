//
//  AppDelegate.swift
//  GifViewer
//
//  Created by Jason Peebles on 2015-04-02.
//  Copyright (c) 2015 Themis Solutions Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.themis.gifviewer")
        return true
    }
}

