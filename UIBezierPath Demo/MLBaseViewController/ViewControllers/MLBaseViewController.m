//
//  MLBaseViewController.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController.h"
#import "MLBaseViewController+NavigationBar.h"

@interface MLBaseViewController () <UINavigationControllerDelegate>

@end

@implementation MLBaseViewController
#pragma mark - UIViewController Life Circle
#pragma mark -
#pragma mark View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Background Color
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2. Set navigationController' delegate to self
    self.navigationController.delegate = self;
    
    // 3. Configure NavigationBar
    [self configureNavigationBar];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Control Points
- (NSMutableArray<MLControlPointView *> *)controlPoints {
    
    if (!_controlPoints) {
        
        _controlPoints = [[NSMutableArray alloc] init];
    }
    
    return _controlPoints;
}

#pragma mark Lazy Background Image View
- (UIImageView *) backgroundImageView {
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
        [self.view insertSubview: _backgroundImageView
                         atIndex: 0];
    }
    
    return _backgroundImageView;
}


#pragma mark - Public Methods
#pragma mark -
#pragma mark Configure the backgroundImageView
- (void) configureBackgroundImageView {
    
    [self configureBackgroundImageViewWithImage: [UIImage imageNamed: @"BackgroundImage_002"]];
}

#pragma mark Configure the backgroundImageView with a image
- (void) configureBackgroundImageViewWithImage:(UIImage *)image {
    
    self.backgroundImageView.image = image;
}

#pragma mark Configure UI.
- (void) configureUI {
    NSLog(@"%@: %s", [self class], __FUNCTION__);
}

#pragma mark Configure Bezier Path.
- (void) configureBezierPath {
    NSLog(@"%@: %s", [self class], __FUNCTION__);
}

#pragma mark Remove a control point from controlPoints array and superView.
- (void) removeControlPoint:(MLControlPointView *)controlPointView {
    NSLog(@"%@: %s", [self class], __FUNCTION__);
}

#pragma mark Input a coordinate for the controlPointView.
- (void) inputCoordinate:(MLControlPointView *)controlPointView {
    NSLog(@"%@: %s", [self class], __FUNCTION__);
}

#pragma mark Whether need Navigation Bar Hidden
- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController {
    
    BOOL needHideNaivgaionBar = NO;
    
    if (![viewController isKindOfClass: [MLBaseViewController class]]) {
        needHideNaivgaionBar = YES;
    }
    
    return needHideNaivgaionBar;
}

#pragma mark - UINaivgationController Delegate
#pragma mark -
#pragma mark Will Show ViewController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden: [self needHiddenBarInViewController: viewController]
                                             animated: animated];
}


@end
