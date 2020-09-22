//
//  UIView+UIApplicationDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 08/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

@objc public extension UIView {
    
    @objc static let becomeActiveNotification = UIApplication.didBecomeActiveNotification
    @objc static let enterForegroundNotification = UIApplication.didEnterBackgroundNotification
    @objc static let willTerminateNotification = UIApplication.willTerminateNotification
    @objc static let needAnimatedSkeletonKey = "needAnimateSkeleton"
    
    @objc func addAppNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIView.becomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIView.enterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminateNotification), name: UIView.enterForegroundNotification, object: nil)
    }
    
    @objc func removeAppNoticationsObserver() {
        NotificationCenter.default.removeObserver(self, name: UIView.becomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIView.enterForegroundNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        if UserDefaults.standard.bool(forKey: UIView.needAnimatedSkeletonKey) {
            startSkeletonAnimation()
        }
    }
    
    @objc func appDidEnterBackground() {
        UserDefaults.standard.set((isSkeletonActive && isSkeletonAnimated), forKey: UIView.needAnimatedSkeletonKey)
    }
    
    @objc func willTerminateNotification() {
        UserDefaults.standard.set(false, forKey: UIView.needAnimatedSkeletonKey)
    }
}
