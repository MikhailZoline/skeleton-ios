//
//  SkeletonTableViewProtocols.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 06/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

@objc public protocol SkeletonTableViewDataSource: UITableViewDataSource {
    @objc func numSections(in collectionSkeletonView: UITableView) -> Int
    @objc func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
    @objc func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier
}

public extension SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceil(skeletonView.frame.height/skeletonView.rowHeight))
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int { return 1 }

    /// Keeping the misspelled version around until it can be deprecated
    /// Right now, it just calls the new correctly spelled method and returns its result
    @available(*, deprecated, renamed: "collectionSkeletonView(_:cellIdentifierForRowAt:)")
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return collectionSkeletonView(skeletonView, cellIdentifierForRowAt: indexPath)
    }
}

@objc public protocol SkeletonTableViewDelegate: UITableViewDelegate {
    @objc func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier?
    @objc func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier?
}

//public extension SkeletonTableViewDelegate {
//    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
//        return nil
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
//        return nil
//    }
//}
