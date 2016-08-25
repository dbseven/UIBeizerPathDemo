//
//  MLHomePageSectionModel.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomePageSectionModel.h"

@implementation MLHomePageSectionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"list":@"list"
             };
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass: MLViewControllerJumpModel.class];
}

@end
