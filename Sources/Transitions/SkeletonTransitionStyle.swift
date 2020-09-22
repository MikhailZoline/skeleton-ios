// Copyright © 2019 SkeletonView. All rights reserved.

import UIKit

@objc public class SkeletonTransitionStyle: NSObject {
    @objc public var transitionPeriod: TimeInterval
    @objc public init(_ t: TimeInterval = 0.0) {
        transitionPeriod = t
        super.init()
    }
}

@objc public class TransitionNone: SkeletonTransitionStyle {
    
}

@objc public class TransitionCrossDissolve: SkeletonTransitionStyle {
//    @objc public var transitionPeriod: TimeInterval
//    @objc public init(_ t: TimeInterval = 0.0) {
//        transitionPeriod = t
//        super.init()
//    }
}
