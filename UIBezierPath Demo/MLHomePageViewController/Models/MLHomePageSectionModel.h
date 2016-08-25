//
//  MLHomePageSectionModel.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseModel.h"
#import "MLViewControllerJumpModel.h"

@interface MLHomePageSectionModel : MLBaseModel 

/** 标题 */
@property (nonatomic, copy) NSString * title;

/** List */
@property (nonatomic, strong) NSArray<MLViewControllerJumpModel *> *list;

@end
