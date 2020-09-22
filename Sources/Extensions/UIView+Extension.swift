// Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

@objc public class ViewAssociatedKeys: NSObject {
    @objc public static var skeletonable = "skeletonable"
    @objc public static var status = "status"
    @objc public static var skeletonLayer = "layer"
    @objc public  static var flowDelegate = "flowDelegate"
    @objc public static var isSkeletonAnimated = "isSkeletonAnimated"
    @objc public static var viewState = "viewState"
    @objc public static var labelViewState = "labelViewState"
    @objc public static var imageViewState = "imageViewState"
    @objc public static var currentSkeletonConfig = "currentSkeletonConfig"
    @objc public static var skeletonCornerRadius = "skeletonCornerRadius"
}


extension UIView {
    enum Status {
        case on
        case off
    }

    var flowDelegate: SkeletonFlowDelegate? {
        get { return ao_get(pkey: &ViewAssociatedKeys.flowDelegate) as? SkeletonFlowDelegate }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.flowDelegate) }
    }

    var skeletonLayer: SkeletonLayer? {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonLayer) as? SkeletonLayer }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.skeletonLayer) }
    }

    var currentSkeletonConfig: SkeletonConfig? {
        get { return ao_get(pkey: &ViewAssociatedKeys.currentSkeletonConfig) as? SkeletonConfig }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.currentSkeletonConfig) }
    }

    var status: Status! {
        get { return ao_get(pkey: &ViewAssociatedKeys.status) as? Status ?? .off }
        set { ao_set(newValue ?? .off, pkey: &ViewAssociatedKeys.status) }
    }

    var isSkeletonAnimated: Bool! {
        get { return ao_get(pkey: &ViewAssociatedKeys.isSkeletonAnimated) as? Bool ?? false }
        set { ao_set(newValue ?? false, pkey: &ViewAssociatedKeys.isSkeletonAnimated) }
    }
}
