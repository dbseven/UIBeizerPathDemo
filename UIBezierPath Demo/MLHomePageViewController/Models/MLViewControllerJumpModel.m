//
//  MLViewControllerJumpModel.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLViewControllerJumpModel.h"
#import "MLHomePageCell.h"

@implementation MLViewControllerJumpModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"title",
             @"destination":@"destination"
             };
}

- (instancetype)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(stopAnimationNotificationAction)
                                                     name: @"ml_stopAnimation"
                                                   object: nil];
    }
    
    return self;
}

- (void) stopAnimationNotificationAction {
    self.selected = NO;
}

@end
