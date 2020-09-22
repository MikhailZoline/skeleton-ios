// Copyright © 2019 SkeletonView. All rights reserved.

import UIKit

@objc public extension CALayer {
    func insertSublayer(_ layer: SkeletonLayer, at idx: UInt32, transition: SkeletonTransitionStyle, completion: (() -> Void)? = nil) {
        insertSublayer(layer.contentLayer(), at: idx)
        switch transition.transitionPeriod {
        case .zero:
            completion?()
            break
        case let duration:
            layer.contentLayer().setOpacity(from: 0, to: 1, duration: duration, completion: completion)
        }
    }
}

@objc extension UIView {
    func startTransition(transitionBlock: @escaping () -> Void) {
        guard let transitionStyle = currentSkeletonConfig?.transition,
            transitionStyle.transitionPeriod != .zero
            else {
                transitionBlock()
                return
        }
        UIView.transition(with: self,
                          duration: transitionStyle.transitionPeriod,
                          options: .transitionCrossDissolve,
                          animations: transitionBlock,
                          completion: nil)
    }
}
