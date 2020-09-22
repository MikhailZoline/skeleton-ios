//
//  SkeletonAnimationBuilder.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 17/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

@objc public class GradientAnimationPoint : NSObject {

    @objc public let from: CGPoint
    @objc public let to: CGPoint
    
    @objc public init( from:CGPoint, to: CGPoint) {
        self.from =  from
        self.to = to
        super.init()
    }
}

@objc public class GradientDirection: NSObject {
    @objc public static let leftRight = "leftRight"
    @objc public static let rightLeft = "rightLeft"
    @objc public static let topBottom = "topBottom"
    @objc public static let bottomTop = "bottomTop"
    @objc public static let topLeftBottomRight = "topLeftBottomRight"
    @objc public static let bottomRightTopLeft = "bottomRightTopLeft"
    @objc public static let bottomLeftTopRight = "bottomLeftTopRight"
    @objc public static let topRightBottomLeft = "topRightBottomLeft"
    
    @objc public let direction: String
    @objc public init( direction: String ) {
        self.direction = direction
        super.init()
    }
    
    public func slidingAnimation(duration: CFTimeInterval = 1.5) -> SkeletonLayerAnimation {
        return SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: self.direction, duration: duration)
    }

    // codebeat:disable[ABC]
    @objc public func startPoint() -> GradientAnimationPoint {
        switch self.direction {
        case GradientDirection.leftRight:
            return GradientAnimationPoint(from: CGPoint(x:-1, y:0.5), to: CGPoint(x:1, y:0.5))
        case GradientDirection.rightLeft:
            return GradientAnimationPoint(from: CGPoint(x:1, y:0.5), to: CGPoint(x:-1, y:0.5))
        case GradientDirection.topBottom:
            return GradientAnimationPoint(from: CGPoint(x:0.5, y:-1), to: CGPoint(x:0.5, y:1))
        case GradientDirection.bottomTop:
            return GradientAnimationPoint(from: CGPoint(x:0.5, y:1), to: CGPoint(x:0.5, y:-1))
        case GradientDirection.topLeftBottomRight:
            return GradientAnimationPoint(from: CGPoint(x:-1, y:-1), to: CGPoint(x:1, y:1))
        case GradientDirection.bottomRightTopLeft:
            return GradientAnimationPoint(from: CGPoint(x:1, y:1), to: CGPoint(x:-1, y:-1))
        case GradientDirection.bottomLeftTopRight:
            return GradientAnimationPoint(from: CGPoint(x:-1, y:1), to: CGPoint(x:1, y:-1))
        case GradientDirection.topRightBottomLeft:
            return GradientAnimationPoint(from: CGPoint(x:1.25, y:-1.25), to: CGPoint(x:-1.25, y:1.25))
        default:
            return GradientAnimationPoint(from: .zero, to: .zero)
        }
    }
    
@objc public func endPoint() -> GradientAnimationPoint {
    switch self.direction {
        case GradientDirection.leftRight:
            return GradientAnimationPoint(from: CGPoint(x:0, y:0.5), to: CGPoint(x:2, y:0.5))
        case GradientDirection.rightLeft:
            return GradientAnimationPoint( from: CGPoint(x:2, y:0.5), to: CGPoint(x:0, y:0.5))
        case GradientDirection.topBottom:
            return GradientAnimationPoint( from: CGPoint(x:0.5, y:0), to: CGPoint(x:0.5, y:2))
        case GradientDirection.bottomTop:
            return GradientAnimationPoint( from: CGPoint(x:0.5, y:2), to: CGPoint(x:0.5, y:0))
        case GradientDirection.topLeftBottomRight:
            return GradientAnimationPoint( from: CGPoint(x:0, y:0), to: CGPoint(x:2, y:2))
        case GradientDirection.bottomRightTopLeft:
            return GradientAnimationPoint( from: CGPoint(x:2, y:2), to: CGPoint(x:0, y:0))
        case GradientDirection.bottomLeftTopRight:
            return GradientAnimationPoint(from: CGPoint(x:-2, y:2), to: CGPoint(x:0, y:0))
        case GradientDirection.topRightBottomLeft:
            return GradientAnimationPoint(from: CGPoint(x:2, y:-2), to: CGPoint(x:0, y:0))
        default:
        return GradientAnimationPoint(from: .zero, to: .zero)
        }
    }
}

@objc public class SkeletonAnimationBuilder: NSObject {
    @objc public override init() { super.init() }
    
    @objc public func makeSlidingAnimation(withDirection direction: String, duration: CFTimeInterval = 1.5) -> SkeletonLayerAnimation {
        let gradientDirection = GradientDirection(direction: direction)
        return { layer in
            
            let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
            startPointAnim.fromValue = gradientDirection.startPoint().from
            startPointAnim.toValue = gradientDirection.startPoint().to
            
            let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
            endPointAnim.fromValue = gradientDirection.endPoint().from
            endPointAnim.toValue = gradientDirection.endPoint().to
            
            let animGroup = CAAnimationGroup()
            animGroup.animations = [startPointAnim, endPointAnim]
            animGroup.duration = duration
            animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            animGroup.repeatCount = .infinity
            animGroup.isRemovedOnCompletion = false
            
            return animGroup
        }
    }
}
