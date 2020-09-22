//
//  SkeletonGradient.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 05/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

@objc public class SkeletonGradient: NSObject {
    @objc public var gradientColors: [UIColor]
    
    @objc public var colors: [UIColor] {
        return gradientColors
    }
    
    @objc public init(baseColor: UIColor, secondaryColor: UIColor) {
        self.gradientColors = [baseColor, secondaryColor, baseColor]
    }
    
    @objc public init(baseColor: UIColor) {
        self.gradientColors = baseColor.makeGradient()
    }
}
