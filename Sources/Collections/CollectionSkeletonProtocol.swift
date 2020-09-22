//
//  CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

enum CollectionAssociatedKeys {
    static var dummyDataSource = "dummyDataSource"
    static var dummyDelegate = "dummyDelegate"
}

@objc public protocol CollectionSkeleton {
    @objc var skeletonDataSource: SkeletonCollectionDataSource? { get set }
    @objc var skeletonDelegate: SkeletonCollectionDelegate? { get set }
    @objc var estimatedNumberOfRows: Int { get }
    
    @objc func addDummyDataSource()
    @objc func updateDummyDataSource()
    @objc func removeDummyDataSource(reloadAfter: Bool)
    @objc func disableUserInteraction()
    @objc func enableUserInteraction()
}

@objc extension UIScrollView: CollectionSkeleton {
    @objc public var skeletonDataSource: SkeletonCollectionDataSource? {
        get {return nil} set {}
    }
    @objc public var skeletonDelegate: SkeletonCollectionDelegate? {
        get {return nil} set {}
    }
    @objc  public func disableUserInteraction() {
        isUserInteractionEnabled = false; isScrollEnabled = false
    }
    @objc  public func  enableUserInteraction() {
        isUserInteractionEnabled = true; isScrollEnabled = true
    }
    @objc public var estimatedNumberOfRows: Int { return 0 }
    @objc public func addDummyDataSource() {}
    @objc public func updateDummyDataSource() {}
    @objc public func removeDummyDataSource(reloadAfter: Bool) {}
}
