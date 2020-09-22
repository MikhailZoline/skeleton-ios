//
//  UICollectionView+CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

@objc extension UICollectionView {
    @objc public override var estimatedNumberOfRows: Int {
        guard let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        return Int(ceil(frame.height/flowlayout.itemSize.height))
    }
    
    @objc public override var skeletonDataSource: SkeletonCollectionDataSource? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDataSource) as? SkeletonCollectionDataSource }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDataSource)
            self.dataSource = newValue
        }
    }
    
    @objc public override var skeletonDelegate: SkeletonCollectionDelegate? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDelegate) as? SkeletonCollectionDelegate }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDelegate)
            self.delegate = newValue
        }
    }
    
    @objc public override func addDummyDataSource() {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource)
        self.skeletonDataSource = dataSource
        reloadData()
    }
    
    @objc public override func updateDummyDataSource() {
        if (dataSource as? SkeletonCollectionDataSource) != nil {
            reloadData()
        } else {
            addDummyDataSource()
        }
    }
    
    public override func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        self.skeletonDataSource = nil
        self.dataSource = dataSource.originalCollectionViewDataSource
        if reloadAfter { self.reloadData() }
    }
}

@objc extension UICollectionView: GenericCollectionView {
    @objc var scrollView: UIScrollView { return self }
}

@objc public extension UICollectionView {
    @objc func prepareSkeleton(completion: @escaping (Bool) -> Void) {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource, rowHeight: 0.0)
        self.skeletonDataSource = dataSource

        performBatchUpdates({
            self.reloadData()
            self.layoutIfNeeded()
        }) { (done) in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                completion(done)
            }
        }
    }
}
