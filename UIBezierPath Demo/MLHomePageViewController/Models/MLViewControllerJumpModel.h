//
//  MLViewControllerJumpModel.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseModel.h"

@class MLHomePageCell;

@interface MLViewControllerJumpModel : MLBaseModel

/** 标题 */
@property (nonatomic, copy) NSString * title;

/** 跳转视图控制器 */
@property (nonatomic, copy) NSString * destination;

/** 选中状态 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
