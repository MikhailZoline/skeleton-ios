//  Copyright © 2017 SkeletonView. All rights reserved.

import UIKit

@objc public protocol Appearance {
    @objc var tintColor: UIColor { get set }
    @objc var gradient: SkeletonGradient { get set }
    @objc var multilineHeight: CGFloat { get set }
    @objc var multilineSpacing: CGFloat { get set }
    @objc var multilineLastLineFillPercent: Int { get set }
    @objc var multilineCornerRadius: Int { get set }
    @objc var renderSingleLineAsView: Bool { get set }
}

@objc public class SkeletonAppearance: NSObject  {
    @objc public static var shared: Appearance = SkeletonViewAppearance.shared
}


@objc class SkeletonViewAppearance: NSObject, Appearance {
    @objc public static var shared = SkeletonViewAppearance()

    @objc var tintColor: UIColor = .skeletonDefault
    @objc var shadeColor: UIColor = .skeletonShade

    @objc var gradient: SkeletonGradient = SkeletonGradient(baseColor: .skeletonDefault, secondaryColor: .skeletonShade)

    @objc var multilineHeight: CGFloat = 15

    @objc var multilineSpacing: CGFloat = 10

    @objc var multilineLastLineFillPercent: Int = 70

    @objc var multilineCornerRadius: Int = 0
    
    @objc var renderSingleLineAsView: Bool = false
}

