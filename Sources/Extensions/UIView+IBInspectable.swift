//  Copyright © 2017 SkeletonView. All rights reserved.

import UIKit

@objc public extension UIView {
    @IBInspectable
    @objc var isSkeletonable: Bool {
        get { return skeletonable }
        set { skeletonable = newValue }
    }
    
    @IBInspectable
    @objc var skeletonCornerRadius: Float {
        get { return skeletonableCornerRadius }
        set { skeletonableCornerRadius = newValue }
    }
    
    @objc var isSkeletonActive: Bool {
        return status == .on || (subviewsSkeletonables.first(where: { $0.isSkeletonActive }) != nil)
    }
    
    @objc var skeletonable: Bool {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonable) != nil }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.skeletonable) }
    }
    
    var skeletonableCornerRadius: Float {
        get { return ao_get(pkey:&ViewAssociatedKeys.skeletonCornerRadius) as? Float ?? 0.0 }
        set { ao_set(newValue, pkey: &ViewAssociatedKeys.skeletonCornerRadius) }
    }
}

