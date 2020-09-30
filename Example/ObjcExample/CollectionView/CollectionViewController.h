//
//  CollectionViewController.h
//  ObjCSkeletonDemo
//
//  Created by Mikhail Zoline on 8/13/20.
//  Copyright © 2020 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource>
@end
