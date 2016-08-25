//
//  MLBaseViewController.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLControlPointView.h"

@interface MLBaseViewController : UIViewController

/** Control Pointes: all controlPoints, in some view controllers, this array does not contain the beginPoint and the endPoint, such as 'MLBezierPathControlPointViewController' */
@property (nonatomic, strong) NSMutableArray<MLControlPointView *> *controlPoints;

/**
 *  Configure UI. 
 *  Note: SubClass Override Method, In BaseViewController, this method is only implement in the .m file but without doing anything;
 */
- (void) configureUI;

/**
 *  Configure Bezier Path.
 *  Note: SubClass Override Method, In BaseViewController, this method is only implement in the .m file but without doing anything;
 */
- (void) configureBezierPath;

/**
 *  Remove a control point from controlPoints array and superView.
 *  Note: SubClass Override Method, In BaseViewController, this method is only implement in the .m file but without doing anything;
 *
 *  @param controlPointView The controlPointView which you want to remove.
 */
- (void) removeControlPoint:(MLControlPointView *)controlPointView;

/**
 *  Input a coordinate for the controlPointView.
 *  Note: SubClass Override Method, In BaseViewController, this method is only implement in the .m file but without doing anything;
 *
 *  @param controlPointView The controlPointView which you want to set coordinate.
 */
- (void) inputCoordinate:(MLControlPointView *)controlPointView;

@end
