//
//  AppDelegate.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/6/25.
//
import Kingfisher
import UIKit
import GoogleSignIn
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setKingfisherOptions()
        //restore previous logged user
      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if error != nil || user == nil {
          // Show the app's signed-out state.
        } else {
          // Show the app's signed-in state.
//            SessionManager.shared.signIn(ModelContext.init(), user: user)
        }
      }
      return true
    }
    func setKingfisherOptions() {
//        let cache = ImageCache.default
//        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100MB
//        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
//        cache.diskStorage.config.expiration = .days(7) //Cache cleaning in 7 days or .never
    }
}
