//
//  MLBezierPathAnimationViewController_02.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/9/8.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBezierPathAnimationViewController_02.h"
#import "MLBezierPathControlPointViewController.h"
#import "MLBaseViewController+NavigationBar.h"
#import "MLLoadingAnimationView.h"

@interface MLBezierPathAnimationViewController_02 ()

/** Animation View */
@property (nonatomic, strong) MLLoadingAnimationView *animationView;

@end

@implementation MLBezierPathAnimationViewController_02
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
}

#pragma mark - UIViewController Life Circle
#pragma mark -
#pragma mark Load View
- (void)loadView {
    [super loadView];
}

#pragma mark View Did Load
- (void) viewDidLoad {
    [super viewDidLoad];
    
    // 1. Configure UI
    [self configureUI];
    
    // 2. Configure NavigationBar
    [self configureNavigationBar];
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 100, 40);
    [button setTitle: @"Push" forState: UIControlStateNormal];
    [button addTarget: self action: @selector(asdfasdf) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: button];
}

- (void) asdfasdf {
    MLBezierPathControlPointViewController *vc = [[MLBezierPathControlPointViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark View Will Appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

#pragma mark View Did Appear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

#pragma mark View Will Disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

#pragma mark View Did Disappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark Configure UI
- (void) configureUI {
    [super configureUI];
    
    // 1. Animation View
    [self.view addSubview: self.animationView];
    
    // 2. Background Color
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark Configure Navigation Bar
- (void) configureNavigationBar {
    [super configureNavigationBar];
    
    [self addNavigationTitle: @"Loading Animation"];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Animation View
- (MLLoadingAnimationView *)animationView {
    
    if (!_animationView) {
        
        _animationView = [MLLoadingAnimationView loadingAnimationViewWithFrame: CGRectMake(100, 100, 100, 100)];
        _animationView.center = self.view.center;
    }
    
    return _animationView;
}


#pragma mark - Action Methods
#pragma mark -

@end
