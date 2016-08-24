//
//  MLControlPointView.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/24.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 屏幕高度 */
#define kHeight_ScreenHeight [UIScreen mainScreen].bounds.size.height

/** 屏幕宽度 */
#define kWidth_ScreenWidth [UIScreen mainScreen].bounds.size.width

/** 状态栏高度 */
#define kHeight_StatusBarHeight 20


NS_ASSUME_NONNULL_BEGIN

@class MLControlPointView;

/**
 *  控制点类型
 */
typedef NS_ENUM(NSInteger, MLControlPointViewType) {
    /**
     *  控制点
     */
    MLControlPointViewTypeControlPoint = 0,
    /**
     *  起点
     */
    MLControlPointViewTypeBeginPoint = 1,
    /**
     *  终点
     */
    MLControlPointViewTypeEndPoint = 2,
};

/**
 *  MLControlPointView 移动后的回调 Block
 */
typedef void(^MLControlPointViewMoved)(void);

/**
 *  MLControlPointView 删除按钮回调 Block
 */
typedef void(^MLControlPointViewRemoveAction)(MLControlPointView *controlPointView);

/**
 *  MLControlPointView 坐标 Label 点击回调 Block
 */
typedef void(^MLControlPointViewLabelClickAction)(MLControlPointView *controlPointView);



@interface MLControlPointView : UIView

/**
 *  工厂方法, 创建控制点
 *
 *  @param atPoint 控制点坐标
 *
 *  @return 控制点 View 实例
 */
+ (instancetype) controlPointViewWithPoint:(CGPoint)atPoint type:(MLControlPointViewType)type movedBlock:(MLControlPointViewMoved)moved coordinateLabelClickAction:(MLControlPointViewLabelClickAction)labelClickAction;

/** 控制点 */
@property (nonatomic, assign) CGPoint controlPoint;

/** MLControlPointView 移动后的回调 Block */
@property (nonatomic, copy) MLControlPointViewMoved moved;

/** MLControlPointView 删除按钮回调 Block */
@property (nonatomic, copy) MLControlPointViewRemoveAction removeAction;

/** MLControlPointView 坐标 Label 点击回调 Block */
@property (nonatomic, copy) MLControlPointViewLabelClickAction labelClickAction;

/**
 *  显示 Coordinate Label, 过 2s 后自动隐藏
 */
- (void) showCoordinateLabelAndDelayHide;

@end

NS_ASSUME_NONNULL_END