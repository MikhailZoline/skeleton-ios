//
//  CollectionViewCell.m
//  ObjCSkeletonDemo
//
//  Created by Mikhail Zoline on 8/13/20.
//  Copyright © 2020 MZ. All rights reserved.
//
@import SkeletonView;
#import "CollectionViewCell.h"

@interface CollectionViewCell ()
- (void)createLabel;
- (void)createImageView;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSkeletonable = true;
        [self createLabel];
        [self createImageView];
        self.contentView.backgroundColor = UIColor.blueColor;
        self.contentView.layer.borderColor = UIColor.redColor.CGColor;
        self.contentView.layer.borderWidth = 4;
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = true;
    }
    return self;
}

- (void)createLabel {
    label = UILabel.new;
    label.isSkeletonable = true;
    label.text = @"Lorem ipsum";
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview: label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [label.bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor],
        [label.heightAnchor constraintEqualToConstant:40],
        [label.widthAnchor constraintEqualToConstant:self.frame.size.width]
    ] ];
}

- (void)createImageView {
    imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"picture"]];
    imageView.isSkeletonable = true;
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview: imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor],
        [imageView.heightAnchor constraintEqualToConstant:40],
        [imageView.widthAnchor constraintEqualToConstant:self.frame.size.width]
    ] ];
}

@end
