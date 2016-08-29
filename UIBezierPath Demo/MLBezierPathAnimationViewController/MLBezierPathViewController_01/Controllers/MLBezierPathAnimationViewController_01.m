//
//  MLBezierPathAnimationViewController_01.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/29.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBezierPathAnimationViewController_01.h"
#import "MLBaseViewController+NavigationBar.h"
#import "MLSpringView.h"

@interface MLBezierPathAnimationViewController_01 ()

/**
 *  Used to set type to the spring view
 */
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

/**
 *  Spring View
 */
@property (nonatomic, strong) MLSpringView *springView;

@end

@implementation MLBezierPathAnimationViewController_01
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
    
    // 1. Show Button
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(40, 100, [UIScreen mainScreen].bounds.size.width-80, 32);
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
    [button setTitle: @"show"
            forState: UIControlStateNormal];
    [button setTitleColor: [UIColor blackColor]
                 forState: UIControlStateNormal];
    [button addTarget: self.springView
               action: @selector(show)
     forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: button];
    
    // 2. Type Segmented Control
    _segmentedControl = [[UISegmentedControl alloc] initWithItems: @[@"普通", @"详细"]];
    _segmentedControl.frame = CGRectMake(40, 160, CGRectGetWidth(button.frame), 32);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget: self
                          action: @selector(segmentedActions:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview: _segmentedControl];
    
    // 3. Spring View
    [self.view addSubview: self.springView];
}

#pragma mark Configure Navigation Bar
- (void) configureNavigationBar {
    
    [self addNavigationTitle: @"Spring Animation"];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Spring View
- (MLSpringView *)springView {
    
    if (!_springView) {
        CGFloat height = 200;
        _springView = [MLSpringView springViewWithContentViewFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
        _springView.displayType = self.segmentedControl.selectedSegmentIndex;
    }
    
    return _springView;
}


#pragma mark - Action Methods
#pragma mark -
#pragma mark Segmented Control
- (void) segmentedActions:(UISegmentedControl *) seg {
    
    self.springView.displayType = seg.selectedSegmentIndex;
}

@end
