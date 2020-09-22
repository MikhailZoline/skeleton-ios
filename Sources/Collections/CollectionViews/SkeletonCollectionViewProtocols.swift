//
//  SkeletonCollectionViewProtocols.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 06/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit


@objc public protocol SkeletonCollectionViewDataSource: UICollectionViewDataSource {
    @objc func numSections(in collectionSkeletonView: UICollectionView) -> Int
    @objc func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    @objc func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier
    @objc func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier?
}

public extension SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skeletonView.estimatedNumberOfRows
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                supplementaryViewIdentifierOfKind: String,
                                at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return nil
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int { return 1 }
}

@objc public protocol SkeletonCollectionViewDelegate: UICollectionViewDelegate { }

