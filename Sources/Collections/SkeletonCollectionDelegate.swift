//
//  SkeletonCollectionDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 30/03/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

@objc public class SkeletonCollectionDelegate: NSObject {
    @objc public weak var originalTableViewDelegate: SkeletonTableViewDelegate?
    @objc public weak var originalCollectionViewDelegate: SkeletonCollectionViewDelegate?
    
    init(tableViewDelegate: SkeletonTableViewDelegate? = nil, collectionViewDelegate: SkeletonCollectionViewDelegate? = nil) {
        self.originalTableViewDelegate = tableViewDelegate
        self.originalCollectionViewDelegate = collectionViewDelegate
    }
}

// MARK: - UITableViewDelegate
@objc extension SkeletonCollectionDelegate: UITableViewDelegate {
    @objc public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let viewIdentifier = originalTableViewDelegate?.collectionSkeletonView(tableView, identifierForHeaderInSection: section),
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier) {

            skeletonViewIfContainerSkeletonIsActive(container: tableView, view: header)
            return header
        }

        return nil
    }

    @objc public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let viewIdentifier = originalTableViewDelegate?.collectionSkeletonView(tableView, identifierForFooterInSection: section),
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier) {

            skeletonViewIfContainerSkeletonIsActive(container: tableView, view: footer)
            return footer
        }

        return nil
    }

    @objc public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        view.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    @objc public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        view.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    @objc public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
@objc extension SkeletonCollectionDelegate: UICollectionViewDelegate { }

@objc extension SkeletonCollectionDelegate {
    private func skeletonViewIfContainerSkeletonIsActive(container: UIView, view: UIView) {
        guard container.isSkeletonActive,
              let skeletonConfig = container.currentSkeletonConfig else {
            return
        }

        view.showSkeleton(skeletonConfig: skeletonConfig)
    }
}
