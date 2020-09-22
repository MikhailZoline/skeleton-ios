// Copyright © 2020 SkeletonView. All rights reserved.

#import "TableViewCell.h"

@interface TableViewCell ()

@end

@implementation TableViewCell

- (void)configureAvatar {
    _avatar.layer.cornerRadius = 5;
    _avatar.layer.masksToBounds = true;
}

- (void)configureLabel {
    _label1.layer.cornerRadius = 5;
    _label1.layer.masksToBounds = true;
}

- (void)awakeFromNib {
    [super awakeFromNib];    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configureAvatar];
        [self configureLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

