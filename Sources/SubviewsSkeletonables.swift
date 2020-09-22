//  Copyright © 2018 SkeletonView. All rights reserved.

import UIKit

@objc public extension UIView {
    @objc var subviewsSkeletonables: [UIView] {
        return subviewsToSkeleton.filter { $0.isSkeletonable }
    }

    @objc var subviewsToSkeleton: [UIView] {
        return subviews
    }
}

@objc public extension UITableView {
    @objc override var subviewsToSkeleton: [UIView] {
        return visibleCells + visibleSectionHeaders + visibleSectionFooters
    }
}

@objc public extension UITableViewCell {
    @objc override var subviewsToSkeleton: [UIView] {
        return contentView.subviews
    }
}

@objc public extension UITableViewHeaderFooterView {
    @objc override var subviewsToSkeleton: [UIView] {
        return contentView.subviews
    }
}

@objc public extension UICollectionView {
    @objc override var subviewsToSkeleton: [UIView] {
        return subviews
    }
}

@objc public extension UICollectionViewCell {
    @objc override var subviewsToSkeleton: [UIView] {
        return contentView.subviews
    }
}

@objc public extension UIStackView {
    @objc override var subviewsToSkeleton: [UIView] {
        return arrangedSubviews
    }
}
