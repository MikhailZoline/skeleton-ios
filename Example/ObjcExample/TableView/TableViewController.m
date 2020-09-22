//  TableViewController.m
//  ObjCSkeletonDemo
//
//  Created by Mikhail Zoline on 8/13/20.
//  Copyright © 2020 MZ. All rights reserved.
//

@import SkeletonView;
#import "ObjcExample-Swift.h"
#import "TableViewCell.h"
#import "TableViewController.h"

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIView *colorSelectedView;
@property (weak, nonatomic) IBOutlet UISwitch *switchAnimated;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skeletonTypeSelector;
@property (weak, nonatomic) IBOutlet UIButton *showOrHideSkeletonButton;

@property (weak, nonatomic) IBOutlet UILabel *transitionDurationLabel;
@property (weak, nonatomic) IBOutlet UIStepper *transitionDurationStepper;

@property (nonatomic, readonly, assign) BOOL type;
@end

@implementation TableViewController

- (void)configureTableView {
    _tableView.isSkeletonable = true;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 120.0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 20.0;
    _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionFooterHeight = 20.0;
    
    [_tableView registerClass: HeaderFooterSection.class forHeaderFooterViewReuseIdentifier:@"FooterIdentifier"];
    [_tableView registerClass: HeaderFooterSection.class forHeaderFooterViewReuseIdentifier:@"HeaderIdentifier"];
}

- (void)configureColorSelectedView {
    _colorSelectedView.layer.cornerRadius = 5;
    _colorSelectedView.layer.masksToBounds = true;
    _colorSelectedView.backgroundColor = SkeletonAppearance.shared.tintColor;
    _colorSelectedView.tintColor = [Colors color:16];
}

- (void)configureAvatarImage {
    _avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2;
    _avatarImage.layer.masksToBounds = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _transitionDurationStepper.value = 0.25;
    [self configureTableView];
    [self configureColorSelectedView];
    [self configureAvatarImage];
    [self showSkeleton];
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

- (IBAction)transitionDurationStepperAction:(id)sender {
    _transitionDurationLabel.text = [NSString stringWithFormat:@"Fade duration: %.2f s", _transitionDurationStepper.value];
    if (self.view.isSkeletonActive) { [self showSkeleton]; }
}

- (IBAction)changeSkeletonType:(id)sender {
    [self refreshSkeleton];
}

- (IBAction)showOrHideSkeleton:(id)sender {
    [_showOrHideSkeletonButton setTitle: self.view.isSkeletonActive ? @"Show skeleton" : @"Hide skeleton" forState:UIControlStateNormal];
    self.view.isSkeletonActive ? [self hideSkeleton] : [self showSkeleton];
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
    SkeletonGradient* gradient = [[SkeletonGradient alloc] initWithBaseColor:_colorSelectedView.backgroundColor secondaryColor:_tableView.tintColor];
    
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

+ (NSArray *)lorem
{
    static NSArray *_lorem;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lorem = @[@"Lorem ipsum", @"dolor sit", @"er elit", @"lamet", @"consectetaur", @"cillium", @"adipisicing", @"pecu sed", @"do eiusmod", @"tempor", @"incididunt", @"ut labore", @"et dolore", @"magna aliqua" ];
    });
    return _lorem;
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
        __weak TableViewController* weakSelf = self;
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

// MARK: - SkeletonTableViewDataSource

- (NSInteger)numSectionsIn:(UITableView *)collectionSkeletonView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)collectionSkeletonView:(UITableView *)skeletonView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSString *)collectionSkeletonView:(UITableView *)skeletonView cellIdentifierForRowAt:(NSIndexPath *)indexPath {
    return @"CellIdentifier";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.label1.text = TableViewController.lorem[indexPath.row];
    
    return cell;
}
// MARK: - SkeletonTableViewDelegate
- (NSString *)collectionSkeletonView:(UITableView *)skeletonView identifierForHeaderInSection:(NSInteger)section {
    return @"HeaderIdentifier";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderFooterSection *header = (HeaderFooterSection*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderIdentifier"];
    header.textLabel.text = TableViewController.lorem.firstObject;
    return header;
}

- (NSString *)collectionSkeletonView:(UITableView *)skeletonView identifierForFooterInSection:(NSInteger)section {
    return @"FooterIdentifier";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HeaderFooterSection *footer = (HeaderFooterSection*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FooterIdentifier"];
    footer.textLabel.text = TableViewController.lorem.lastObject;
    return footer;
}

@end

