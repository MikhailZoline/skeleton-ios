//
//  SkeletonLayer.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation

@objc public class SkeletonType: NSObject {
    @objc public static let solid = true
    @objc public static let gradient = false
    
    var solidGradient = SkeletonType.solid
    
    @objc public init( solidOrGradient: Bool = SkeletonType.solid) {
        self.solidGradient = solidOrGradient
        super.init()
    }
    
    @objc public func layer() -> CALayer {
        return self.solidGradient ? CALayer() : CAGradientLayer()
    }
    
    @objc public func layerAnimation() -> SkeletonLayerAnimation {
        return self.solidGradient ? { $0.pulse } : { $0.angled }
    }
    
    @objc public var isGardient: Bool {
        return solidGradient == SkeletonType.gradient
    }
    
    @objc public var isSolid: Bool {
        return solidGradient == SkeletonType.solid
    }
}

@objc public class SkeletonLayer: NSObject {
    private var maskLayer: CALayer
    private weak var holder: UIView?
    
    @objc public func type() -> SkeletonType {
        return maskLayer is CAGradientLayer ? SkeletonType(solidOrGradient: SkeletonType.gradient) : SkeletonType(solidOrGradient: SkeletonType.solid)
    }
    
    @objc public func contentLayer() -> CALayer {
        return maskLayer
    }
    
    @objc public init(type: SkeletonType, colors: [UIColor], skeletonHolder holder: UIView) {
        self.holder = holder
        self.maskLayer = type.layer()
        self.maskLayer.anchorPoint = .zero
        self.maskLayer.bounds = holder.maxBoundsEstimated
        self.maskLayer.cornerRadius = CGFloat(holder.skeletonCornerRadius)
        super.init()
        addTextLinesIfNeeded()
        self.maskLayer.tint(withColors: colors)
    }
    
    @objc public func update(usingColors colors: [UIColor]) {
        layoutIfNeeded()
        maskLayer.tint(withColors: colors)
    }

    @objc public func layoutIfNeeded() {
        if let bounds = holder?.maxBoundsEstimated {
            maskLayer.bounds = bounds
        }
        updateLinesIfNeeded()
    }
    
   @objc public func removeLayer(transition: SkeletonTransitionStyle, completion: (() -> Void)? = nil) {
        
        switch transition.transitionPeriod {
        case .zero:
            maskLayer.removeFromSuperlayer()
            completion?()
        default:
            maskLayer.setOpacity(from: 1, to: 0, duration: transition.transitionPeriod) {
                self.maskLayer.removeFromSuperlayer()
                completion?()
            }
        }
    }

    /// If there is more than one line, or custom preferences have been set for a single line, draw custom layers
    @objc public func addTextLinesIfNeeded() {
        guard let textView = holderAsTextView() else { return }
        
        let config = SkeletonMultilinesLayerConfig(lines: textView.numLines(),
                                                   type: type(),
                                                   lineHeight: textView.multilineTextFont != nil ? textView.multilineTextFont!.lineHeight : 0,
                                                   lastLineFillPercent: textView.lastLineFillingPercent,
                                                   multilineCornerRadius: textView.multilineCornerRadius,
                                                   multilineSpacing: textView.multilineSpacing,
                                                   paddingInsets: textView.paddingInsets)

        maskLayer.addMultilinesLayers(for: config)
    }
    
    @objc public func updateLinesIfNeeded() {
        guard let textView = holderAsTextView() else { return }
        
        let config = SkeletonMultilinesLayerConfig(lines: textView.numLines(),
                                                   type: type(),
                                                   lineHeight: textView.multilineTextFont != nil ? textView.multilineTextFont!.lineHeight : 0,
                                                   lastLineFillPercent: textView.lastLineFillingPercent,
                                                   multilineCornerRadius: textView.multilineCornerRadius,
                                                   multilineSpacing: textView.multilineSpacing,
                                                   paddingInsets: textView.paddingInsets)
        
        maskLayer.updateMultilinesLayers(for: config)
        
    }
    
    @objc public func holderAsTextView() -> ContainsMultilineText? {
        guard let textView = holder as? ContainsMultilineText,
            (textView.numLines() == 0 || textView.numLines() > 1 || textView.numLines() == 1 && !SkeletonAppearance.shared.renderSingleLineAsView) else {
                return nil
        }
        return textView
    }
}

@objc public extension SkeletonLayer {
    @objc func start(_ anim: SkeletonLayerAnimation? = nil, completion: (() -> Void)? = nil) {
        let animation = anim ?? type().layerAnimation()
        contentLayer().playAnimation(animation, key: "skeletonAnimation", completion: completion)
    }

    @objc func stopAnimation() {
        contentLayer().stopAnimation(forKey: "skeletonAnimation")
    }
}
