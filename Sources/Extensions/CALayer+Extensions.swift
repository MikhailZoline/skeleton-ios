//
//  SkeletonLayer+Animations.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 03/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

@objc public extension CALayer {
    @objc func tint(withColors colors: [UIColor]) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            backgroundColor = colors.first?.cgColor
        }) {
            $0.tint(withColors: colors)
        }
    }
}

@objc public extension CAGradientLayer {
    @objc override func tint(withColors colors: [UIColor]) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            self.colors = colors.map { $0.cgColor }
        }) {
            $0.tint(withColors: colors)
        }
    }
}

@objc public class SkeletonMultilinesLayerConfig: NSObject {
	@objc public var lines: Int
	@objc public var lineHeight: CGFloat
    @objc public var type: SkeletonType
	@objc public var lastLineFillPercent: Int
	@objc public var multilineCornerRadius: Int
	@objc public var multilineSpacing: CGFloat
	@objc public var paddingInsets: UIEdgeInsets
    @objc public init( lines: Int, type: SkeletonType,
                       lineHeight: CGFloat = 0,
                       lastLineFillPercent: Int,
                       multilineCornerRadius: Int,
                       multilineSpacing: CGFloat,
                       paddingInsets: UIEdgeInsets) {
        self.lines = lines
        self.lineHeight = lineHeight
        self.type = type
        self.lastLineFillPercent = lastLineFillPercent
        self.multilineCornerRadius = multilineCornerRadius
        self.multilineSpacing = multilineSpacing
        self.paddingInsets = paddingInsets
        super.init()
    }
}


// MARK: Skeleton sublayers
@objc extension CALayer {
    @objc public static let skeletonSubLayersName = "SkeletonSubLayersName"

    @objc public var skeletonSublayers: [CALayer] {
        return sublayers?.filter { $0.name == CALayer.skeletonSubLayersName } ?? [CALayer]()
    }
    
	@objc public func addMultilinesLayers(for config: SkeletonMultilinesLayerConfig) {
        let numberOfSublayers = config.lines == 1 ? 1 : calculateNumLines(for: config)
        var height = config.lineHeight == 0 ? SkeletonAppearance.shared.multilineHeight : config.lineHeight
        if numberOfSublayers == 1 {
            height = bounds.height
        }

        let layerBuilder = SkeletonMultilineLayerBuilder()
			.setSkeletonType(config.type)
			.setCornerRadius(config.multilineCornerRadius)
			.setMultilineSpacing(config.multilineSpacing)
            .setPadding(config.paddingInsets)
            .setHeight(height)
    
        (0..<numberOfSublayers).forEach { index in
			let width = calculatedWidthForLine(at: index, totalLines: numberOfSublayers, lastLineFillPercent: config.lastLineFillPercent, paddingInsets: config.paddingInsets)
            if let layer = layerBuilder
                .setIndex(index)
                .setWidth(width)
                .build() {
                addSublayer(layer)
            }
        }
    }

    @objc public func updateMultilinesLayers(for config: SkeletonMultilinesLayerConfig) {
        let currentSkeletonSublayers = skeletonSublayers
        let numberOfSublayers = currentSkeletonSublayers.count
        let lastLineFillPercent = config.lastLineFillPercent
        let paddingInsets = config.paddingInsets
        let multilineSpacing = config.multilineSpacing
        var height = config.lineHeight == 0 ? SkeletonAppearance.shared.multilineHeight : config.lineHeight
        if numberOfSublayers == 1 {
            height = bounds.height
        }
        
        for (index, layer) in currentSkeletonSublayers.enumerated() {
            let width = calculatedWidthForLine(at: index, totalLines: numberOfSublayers, lastLineFillPercent: lastLineFillPercent, paddingInsets: paddingInsets)
            layer.updateLayerFrame(for: index, size: CGSize(width: width, height: height), multilineSpacing: multilineSpacing, paddingInsets: paddingInsets)
        }
    }

    @objc public func calculatedWidthForLine(at index: Int, totalLines: Int, lastLineFillPercent: Int, paddingInsets: UIEdgeInsets) -> CGFloat {
        var width = bounds.width - paddingInsets.left - paddingInsets.right
        if index == totalLines - 1 && totalLines != 1 {
            width = width * CGFloat(lastLineFillPercent) / 100
        }
        return width
    }

    @objc public func updateLayerFrame(for index: Int, size: CGSize, multilineSpacing: CGFloat, paddingInsets: UIEdgeInsets) {
        let spaceRequiredForEachLine = SkeletonAppearance.shared.multilineHeight + multilineSpacing
        frame = CGRect(x: paddingInsets.left, y: CGFloat(index) * spaceRequiredForEachLine + paddingInsets.top, width: size.width, height: size.height)
    }

	@objc public func calculateNumLines(for config: SkeletonMultilinesLayerConfig) -> Int {
        let requiredSpaceForEachLine = (config.lineHeight == 0 ? SkeletonAppearance.shared.multilineHeight : config.lineHeight) + config.multilineSpacing
		var numberOfSublayers = Int(round(CGFloat(bounds.height - config.paddingInsets.top - config.paddingInsets.bottom)/CGFloat(requiredSpaceForEachLine)))
		if config.lines != 0,  config.lines <= numberOfSublayers { numberOfSublayers = config.lines }
        return numberOfSublayers
    }
}

// MARK: Animations
@objc public extension CALayer {
    @objc var pulse: CAAnimation {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        pulseAnimation.fromValue = backgroundColor
        pulseAnimation.toValue = UIColor(cgColor: backgroundColor ?? UIColor.lightGray.cgColor).complementaryColor.cgColor
        pulseAnimation.duration = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.isRemovedOnCompletion = false
        return pulseAnimation
    }
    
    @objc var sliding: CAAnimation {
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnim.fromValue = CGPoint(x: -1, y: 0.5)
        startPointAnim.toValue = CGPoint(x:1, y: 0.5)
        
        let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnim.fromValue = CGPoint(x: 0, y: 0.5)
        endPointAnim.toValue = CGPoint(x:2, y: 0.5)
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim]
        animGroup.duration = 1.5
        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animGroup.repeatCount = .infinity
        animGroup.isRemovedOnCompletion = false
        
        return animGroup
    }
    
    @objc var angled: CAAnimation {
        return SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: GradientDirection.topLeftBottomRight, duration: 2.0)(self)
    }
    
    @objc func playAnimation(_ anim: SkeletonLayerAnimation, key: String, completion: (() -> Void)? = nil) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            DispatchQueue.main.async { CATransaction.begin() }
            DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
            add(anim(self), forKey: key)
            DispatchQueue.main.async { CATransaction.commit() }
        }) {
            $0.playAnimation(anim, key: key, completion: completion)
        }
    }
    
    @objc func stopAnimation(forKey key: String) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            removeAnimation(forKey: key)
        }) {
            $0.stopAnimation(forKey: key)
        }
    }
}

@objc public extension CALayer {
    @objc func setOpacity(from: Int, to: Int, duration: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.async { CATransaction.begin() }
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
        add(animation, forKey: "setOpacityAnimation")
        DispatchQueue.main.async { CATransaction.commit() }
    }
}
