// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

/// Used to store all config needed to activate the skeleton layer.
@objc public class SkeletonConfig: NSObject {
    /// Type of skeleton layer
    @objc public let type: SkeletonType
    
    /// Colors used in skeleton layer
    @objc public let colors: [UIColor]
    
    /// If type is gradient, which gradient direction
    @objc public let gradientDirection: GradientDirection?
    
    /// Specify if skeleton is animated or not
    @objc public let animated: Bool
    
    /// Used to execute a custom animation
    @objc public let animation: SkeletonLayerAnimation?
    
    ///  Transition style
    @objc public var transition: SkeletonTransitionStyle
    
    @objc public init(
        type: SkeletonType,
        colors: [UIColor],
        gradientDirection: GradientDirection? = nil,
        animated: Bool = false,
        animation: SkeletonLayerAnimation? = nil,
        transition: SkeletonTransitionStyle = SkeletonTransitionStyle(0.25)
        ) {
        self.type = type
        self.colors = colors
        self.gradientDirection = gradientDirection
        self.animated = animated
        self.animation = animation
        self.transition = transition
        super.init()
    }
}
