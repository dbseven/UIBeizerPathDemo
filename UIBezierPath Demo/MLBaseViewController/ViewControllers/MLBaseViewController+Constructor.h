//
//  MLBaseViewController+Constructor.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLBaseViewController (Constructor)

/**
 *  Factory method
 *
 *  @return A subclass of MLBaseViewController
 */
+ (__kindof MLBaseViewController *) viewController;

@end
