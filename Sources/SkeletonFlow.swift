//  Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

@objc public protocol SkeletonFlowDelegate {
    @objc func willBeginShowingSkeletons(rootView: UIView)
    @objc func didShowSkeletons(rootView: UIView)
    @objc func willBeginUpdatingSkeletons(rootView: UIView)
    @objc func didUpdateSkeletons(rootView: UIView)
    @objc func willBeginLayingSkeletonsIfNeeded(rootView: UIView)
    @objc func didLayoutSkeletonsIfNeeded(rootView: UIView)
    @objc func willBeginHidingSkeletons(rootView: UIView)
    @objc func didHideSkeletons(rootView: UIView)
}

@objc public class SkeletonFlowHandler: NSObject, SkeletonFlowDelegate {
    @objc public func willBeginShowingSkeletons(rootView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "willBeginShowingSkeletons"), object: rootView, userInfo: nil)
        rootView.addAppNotificationsObservers()
    }

    @objc public func didShowSkeletons(rootView: UIView) {
        printSkeletonHierarchy(in: rootView)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didShowSkeletons"), object: rootView, userInfo: nil)
    }

    @objc public func willBeginUpdatingSkeletons(rootView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "willBeginUpdatingSkeletons"), object: rootView, userInfo: nil)
    }

    @objc public func didUpdateSkeletons(rootView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateSkeletons"), object: rootView, userInfo: nil)
    }

     @objc public func willBeginLayingSkeletonsIfNeeded(rootView: UIView) {
    }

     @objc public func didLayoutSkeletonsIfNeeded(rootView: UIView) {
    }

     @objc public func willBeginHidingSkeletons(rootView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"willBeginHidingSkeletons"), object: rootView, userInfo: nil)
        rootView.removeAppNoticationsObserver()
    }

     @objc public func didHideSkeletons(rootView: UIView) {
        rootView.flowDelegate = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didHideSkeletons"), object: rootView, userInfo: nil)
    }
}
