//
//  MLBaseViewController+NavigationBar.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLBaseViewController (NavigationBar)

/**
 *  添加导航栏标题
 *
 *  @param image 标题
 */
- (void) addNavigationTitle:(NSString *)title;

/**
 *  添加返回按钮
 */
- (void) addBackNavigationBarItem;


/**
 *  Configure Navigation Bar
 */
- (void) configureNavigationBar;

@end
