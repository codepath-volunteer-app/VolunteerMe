//
//  AppDelegate.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/6/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit
import Parse
import UIColor_Hex_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let serverEndpointUrl: String = "https://volunteerme.herokuapp.com/parse"
  let applicationId: String = "volunteerme"

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    initializeParse()
    customAppearance()
    testApiCalls()

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  fileprivate func initializeParse() -> () {
    Parse.initialize(
      with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
        configuration.applicationId = self.applicationId
        configuration.clientKey = nil  // set to nil assuming you have not set clientKey
        configuration.server = self.serverEndpointUrl
      })
    )
  }

  // Change app color here
  fileprivate func customAppearance(){

    let navigationBarAppearace = UINavigationBar.appearance()
    navigationBarAppearace.barTintColor = UIColor("#0084b4")
    navigationBarAppearace.tintColor = UIColor("#ffffff")
    navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName : UIColor("#ffffff")]
  }

  fileprivate func testApiCalls() {
    print(User.current())

    // Should preload all the tags at the load of the app
    Tag.findTagsByNameArray(["fun", "full day", "reading", "arts"]) {
        (tags: [Tag]) in
        
        print("==========================")
        print("all the loaded tags")
        print("==========================")
        for tag in Tag.findTagsByNameArraySync(["fun", "full day", "reading", "arts"]) {
            tag.printHumanReadableTestString()
        }

        // find tags by search term
        print("==========================")
        print("find tags with search term")
        print("==========================")
        let matchingTags = Tag.queryTagsFromCache("full")
        for tag in matchingTags {
            tag.printHumanReadableTestString()
        }

    }
  }
}
