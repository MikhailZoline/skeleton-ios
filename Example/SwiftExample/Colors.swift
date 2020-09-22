//
//  Colors.swift
//  ObjCSkeletonDemo
//
//  Created by Mikhail Zoline on 8/17/20.
//  Copyright © 2020 MZ. All rights reserved.
//

import UIKit
import SkeletonView

@objc public class Colors: NSObject {
    static let colors = [(UIColor.skeletonDefault,"skeletonDefault"),(UIColor.turquoise,"turquoise"), (UIColor.emerald,"emerald"),(UIColor.greenSea,"greenSea"),(UIColor.peterRiver,"peterRiver"), (UIColor.amethyst,"amethyst"),(UIColor.wetAsphalt,"wetAsphalt"), (UIColor.nephritis,"nephritis"), (UIColor.belizeHole,"belizeHole"), (UIColor.wisteria,"wisteria"), (UIColor.midnightBlue,"midnightBlue"), (UIColor.sunFlower,"sunFlower"), (UIColor.carrot,"carrot"), (UIColor.alizarin,"alizarin"),(UIColor.clouds,"clouds"), (UIColor.darkClouds,"darkClouds"), (UIColor.concrete,"concrete"), (UIColor.flatOrange,"flatOrange"), (UIColor.pumpkin,"pumpkin"), (UIColor.pomegranate,"pomegranate"), (UIColor.silver,"silver"), (UIColor.asbestos,"asbestos"), (UIColor.base20White, "base20White"), (UIColor.lighterGray, "lighterGray")]
    
    @objc public static func color(_ i: Int) -> UIColor {
        return colors[i].0
    }
    @objc public static func title(_ i: Int) -> String {
        return colors[i].1
    }
    @objc public static var count: Int = {return Colors.colors.count}()
}

