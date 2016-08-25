//
//  MLBaseCell+Shaking.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell.h"

/** Cell Shaking 动画开始的通知 */
static NSString *const kMLNotificationName_Shaking_Begin = @"kMLNotificationName_Shaking_Begin";

/** Cell Shaking 动画结束的通知 */
static NSString *const kMLNotificationName_Shaking_End = @"kMLNotificationName_Shaking_End";


typedef void(^MLShakingOver)(void);


@interface MLBaseCell (Shaking)

/**
 *  被点击之后的震动效果
 */
- (BOOL) shake;

/**
 *  注册 Shaking 相关的通知
 */
- (void) registerNotificationCenter;

/** 是否正在 Shaking */
@property (nonatomic, assign, getter=isShaking) BOOL shaking;


/** 需要 Shake 的 View */
@property (nonatomic, weak) UIView *shakingView;


/** Shaking 后的 回调 Block */
@property (nonatomic, copy) MLShakingOver shakingOver;


@end
