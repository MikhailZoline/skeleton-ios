//  Copyright © 2017 SkeletonView. All rights reserved.

import Foundation

//@objc public protocol AssociatedObjects: class {}

@objc extension NSObject {
    /// wrapper around `objc_getAssociatedObject`
    @objc public func ao_get(pkey: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, pkey)
    }

    /// wrapper around `objc_setAssociatedObject`
    @objc public func ao_setOptional(_ value: Any?, pkey: UnsafeRawPointer) {
        guard let value = value else { return }
        objc_setAssociatedObject(self, pkey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// wrapper around `objc_setAssociatedObject`
    @objc public func ao_set(_ value: Any, pkey: UnsafeRawPointer ) {
        objc_setAssociatedObject(self, pkey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// wrapper around 'objc_removeAssociatedObjects'
    @objc public func ao_removeAll() {
        objc_removeAssociatedObjects(self)
    }
}



