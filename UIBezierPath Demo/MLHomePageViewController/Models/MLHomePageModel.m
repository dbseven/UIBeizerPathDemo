//
//  MLHomePageModel.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomePageModel.h"

@implementation MLHomePageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"list":@"list"
             };
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass: MLHomePageSectionModel.class];
}

@end
