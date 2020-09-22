// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

public extension UITextView {
    @IBInspectable
    var lastLineFillPercent: Int {
        get { return lastLineFillingPercent }
        set { lastLineFillingPercent = min(newValue, 100) }
    }

    @IBInspectable
    var linesCornerRadius: Int {
        get { return multilineCornerRadius }
        set { multilineCornerRadius = min(newValue, 10) }
    }

    @IBInspectable
    var skeletonLineSpacing: CGFloat {
        get { return multilineSpacing }
        set { multilineSpacing = min(newValue, 10) }
    }

    @IBInspectable
    var skeletonPaddingInsets: UIEdgeInsets {
        get { return paddingInsets }
        set { paddingInsets = newValue }
    }
}

@objc extension UITextView: ContainsMultilineText {
    
    @objc public func numLines() -> Int { return 0 }
    
    public var multilineTextFont: UIFont? {
		return font
	}
	
    public var lastLineFillingPercent: Int {
        get {
            let defaultValue = SkeletonAppearance.shared.multilineLastLineFillPercent
            return ao_get(pkey: &MultilineAssociatedKeys.lastLineFillingPercent) as? Int ?? defaultValue
        }
        set { ao_set(newValue, pkey: &MultilineAssociatedKeys.lastLineFillingPercent) }
    }

    public var multilineCornerRadius: Int {
        get {
            let defaultValue = SkeletonAppearance.shared.multilineCornerRadius
            return ao_get(pkey: &MultilineAssociatedKeys.multilineCornerRadius) as? Int ?? defaultValue
        }
        set { ao_set(newValue, pkey: &MultilineAssociatedKeys.multilineCornerRadius) }
    }

    public var multilineSpacing: CGFloat {
        get { return ao_get(pkey: &MultilineAssociatedKeys.multilineSpacing) as? CGFloat ?? SkeletonAppearance.shared.multilineSpacing }
        set { ao_set(newValue, pkey: &MultilineAssociatedKeys.multilineSpacing) }
    }

    public var paddingInsets: UIEdgeInsets {
        get { return ao_get(pkey: &MultilineAssociatedKeys.paddingInsets) as? UIEdgeInsets ?? .zero }
        set { ao_set(newValue, pkey: &MultilineAssociatedKeys.paddingInsets) }
    }
}
