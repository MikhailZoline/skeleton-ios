//
//  ViewController.m
//  ObjCSkeletonDemo
//
//  Created by Mikhail Zoline on 8/13/20.
//  Copyright © 2020 MZ. All rights reserved.
//
@import SkeletonView;
#import "ObjCExample-Swift.h"
#import "CollectionViewController.h"

@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIView *colorSelectedView;
@property (weak, nonatomic) IBOutlet UISwitch *switchAnimated;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skeletonTypeSelector;
@property (weak, nonatomic) IBOutlet UIButton *showOrHideSkeletonButton;
@property (weak, nonatomic) IBOutlet UILabel *transitionDurationLabel;
@property (weak, nonatomic) IBOutlet UIStepper *transitionDurationStepper;

@property (nonatomic, readonly, assign) BOOL type;
@end

typedef CAAnimation* (^SkeletonLayerAnimation)(CALayer *);

@implementation CollectionViewController

- (void)configureCollectionView {
    _collectionView.isSkeletonable = true;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.showsVerticalScrollIndicator = false;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
}

- (void)configureAvatarImage {
    _avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2;
    _avatarImage.layer.masksToBounds = true;
}

- (void)configureColorSelectedView {
    _colorSelectedView.layer.cornerRadius = 5;
    _colorSelectedView.layer.masksToBounds = true;
    _colorSelectedView.backgroundColor = SkeletonAppearance.shared.tintColor;
    _colorSelectedView.tintColor = [Colors color:16];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _transitionDurationStepper.value = 0.25;
    [self configureCollectionView];
    [self configureColorSelectedView];
    [self configureAvatarImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.collectionView prepareSkeletonWithCompletion:^(BOOL done) {
        [self showSkeleton];
    }];
}

- (IBAction)changeAnimated:(id)sender {
    if (_switchAnimated.isOn) {
        [self.view startSkeletonAnimation:NULL];
    } else {
        [self.view stopSkeletonAnimation];
    }
}

- (IBAction)btnChangeColorTouchUpInside:(id)sender {
    [self showAlertPicker];
}

- (IBAction)showOrHideSkeleton:(id)sender {
    [_showOrHideSkeletonButton setTitle: self.view.isSkeletonActive ? @"Show skeleton" : @"Hide skeleton" forState:UIControlStateNormal];
    self.view.isSkeletonActive ? [self hideSkeleton] : [self showSkeleton];
}

- (IBAction)transitionDurationStepperAction:(id)sender {
    _transitionDurationLabel.text = [NSString stringWithFormat:@"Fade duration: %.2f s", _transitionDurationStepper.value];
    if (self.view.isSkeletonActive) { [self showSkeleton]; }
}

- (IBAction)changeSkeletonType:(id)sender {
    [self refreshSkeleton];
}

- (BOOL)type {
    return _skeletonTypeSelector.selectedSegmentIndex == 0 ? SkeletonType.solid: SkeletonType.gradient;
}

- (void)showSkeleton {
    [self refreshSkeleton];
}

- (void)hideSkeleton {
    [self.view hideSkeletonWithReloadDataAfter:
     true transition:
     [[SkeletonTransitionStyle alloc]init:
      _transitionDurationStepper.value]];
}

- (void)refreshSkeleton {
    if (self.view.isSkeletonActive) {
        SkeletonTransitionStyle *style = [[SkeletonTransitionStyle alloc]init: 0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideSkeletonWithReloadDataAfter:true transition: style];
        });
    }
    
    [NSThread sleepForTimeInterval:0.1f];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self.type == SkeletonType.gradient) {
            [self showGradientSkeleton];
        } else {
            [self showSolidSkeleton ];
        }
    });
}

- (void)showSolidSkeleton {
    if (_switchAnimated.isOn) {
        [self.view showAnimatedSkeletonUsingColor:
         _colorSelectedView.backgroundColor animation:
         NULL transition:
         [[SkeletonTransitionStyle alloc]init:
          _transitionDurationStepper.value]];
    } else {
        [self.view showSkeletonUsingColor:
         _colorSelectedView.backgroundColor transition:
         [[SkeletonTransitionStyle alloc]init:
          _transitionDurationStepper.value]];
    }
}

- (void)showGradientSkeleton {
    SkeletonGradient* gradient = [[SkeletonGradient alloc] initWithBaseColor:_colorSelectedView.backgroundColor secondaryColor:_collectionView.tintColor];
    
    if (_switchAnimated.isOn) {
        [self.view showAnimatedGradientSkeletonUsingGradient:
         gradient animation:
         NULL transition:
         [[SkeletonTransitionStyle alloc]init:
          _transitionDurationStepper.value]];
    } else {
        [self.view showGradientSkeletonUsingGradient:
         gradient transition:
         [[SkeletonTransitionStyle alloc]init:
          _transitionDurationStepper.value]];
    }
}

- (void)showAlertPicker {
    UIAlertController* alertView =
    [UIAlertController alertControllerWithTitle:
     @"Select color" message:@"\n\n\n\n\n\n" preferredStyle:
     UIAlertControllerStyleAlert];
    
    UIPickerView* pickerView =
    [[UIPickerView alloc] initWithFrame:
     CGRectMake(0.0, 50.0, 260.0, 120.0)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [alertView.view addSubview:pickerView];
    
    UIAlertAction* action =
    [UIAlertAction actionWithTitle:
     @"Ok" style:
     UIAlertActionStyleDefault handler:
     ^(UIAlertAction * _Nonnull action) {
        __weak CollectionViewController* weakSelf = self;
        __weak UIPickerView* weakPicker = pickerView;
        long row = [weakPicker selectedRowInComponent:0];
        weakSelf.colorSelectedView.backgroundColor = [Colors color:row];
        [weakSelf refreshSkeleton];
    }];
    [alertView addAction:action];
    
    UIAlertAction* cancelAction =
    [UIAlertAction actionWithTitle:
     @"Cancel" style:
     UIAlertActionStyleCancel handler:
     NULL];
    [alertView addAction:cancelAction];
    [self presentViewController:
     alertView animated:
     false completion:
     NULL];
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [Colors count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [Colors title:row] ;
}

// MARK: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/3 - 10, self.view.frame.size.width/3 - 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 7, 0, 7);
}

// MARK: - SkeletonCollectionViewDataSource
- (NSString *)collectionSkeletonView:(UICollectionView *)skeletonView supplementaryViewIdentifierOfKind:(NSString *)supplementaryViewIdentifierOfKind at:(NSIndexPath *)indexPath {
    return nil;
}
- (NSInteger)numSectionsIn:(UICollectionView *)collectionSkeletonView {
    return 1;
}

- (NSString *)collectionSkeletonView:(UICollectionView *)skeletonView cellIdentifierForItemAt:(NSIndexPath *)indexPath {
    return @"CollectionViewCell";
}

- (NSInteger)collectionSkeletonView:(UICollectionView *)skeletonView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // this code is not called
    // since SkeletonCollectionViewDataSource does its own imp of this
    //
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [CollectionViewCell init];
    }
    return cell;
}


@end
