//
//  MLHomePageModel.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseModel.h"
#import "MLHomePageSectionModel.h"

@interface MLHomePageModel : MLBaseModel

/** List */
@property (nonatomic, strong) NSArray<MLHomePageSectionModel *> *list;

@end
