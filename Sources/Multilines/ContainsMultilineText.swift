//  Copyright © 2017 SkeletonView. All rights reserved.

import UIKit

enum MultilineAssociatedKeys {
    static var lastLineFillingPercent = "lastLineFillingPercent"
    static var multilineCornerRadius = "multilineCornerRadius"
    static var multilineSpacing = "multilineSpacing"
    static var paddingInsets = "paddingInsets"
}

@objc public protocol ContainsMultilineText {
	var multilineTextFont: UIFont? { get }
    @objc func numLines() -> Int
    var lastLineFillingPercent: Int { get }
    var multilineCornerRadius: Int { get }
    var multilineSpacing: CGFloat { get }
    var paddingInsets: UIEdgeInsets { get }
}

 public extension ContainsMultilineText {
    func numLines() -> Int { return 0 }
}
