//
//  MLLoadingAnimationView.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/9/8.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLLoadingAnimationView : UIView

/**
 *  Factory Method
 *
 *  @param frame Frame
 *
 *  @return Instance Of MLLoadingAnimationView
 */
+ (instancetype) loadingAnimationViewWithFrame:(CGRect)frame;

/**
 *  Begin Loading Animation
 */
- (void) beginLoading;

/**
 *  Stop Loading Animation
 */
- (void) stopLoading;

@end
