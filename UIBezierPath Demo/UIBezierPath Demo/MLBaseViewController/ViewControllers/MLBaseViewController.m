//
//  MLBaseViewController.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLBaseViewController ()

@end

@implementation MLBaseViewController
#pragma mark - UIViewController Life Circle
#pragma mark -
#pragma mark View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - Public Methods
#pragma mark -
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
    NSLog(@"%@: %s", [self class], __FUNCTION__);}

@end
