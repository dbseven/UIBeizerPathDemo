//
//  MLBaseViewController+Constructor.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController+Constructor.h"

@implementation MLBaseViewController (Constructor)

#pragma mark - Initialize Methods
#pragma mark -
#pragma mark Factory Method
+ (MLBaseViewController *)viewController {
    
    return [[[self class] alloc] init];
}

@end
