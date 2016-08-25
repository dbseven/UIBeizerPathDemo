//
//  MLBaseViewController+NavigationBar.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseViewController+NavigationBar.h"

@implementation MLBaseViewController (NavigationBar)

#pragma mark - Public Methods
#pragma mark -
#pragma mark Add Back Button
- (void) addBackNavigationBarItem {
    
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
    [button setImage: [UIImage imageNamed: @"nav_icon_back_normal"] forState: UIControlStateNormal];
    [button addTarget: self action: @selector(popAction:) forControlEvents: UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 5);
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    placeHolderItem.width = -15;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView: button];
    self.navigationItem.leftBarButtonItems = @[placeHolderItem, backItem];
}

#pragma mark Add Navigation Title
- (void) addNavigationTitle:(NSString *)title {
    
    //    1. 计算 Label 宽度
    CGFloat labelWidth = [title boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size.width;
    
    //    2. 创建 TitleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, labelWidth, 44)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //    3. 设置导航栏的 TitleView
    self.navigationItem.titleView = titleLabel;
}

#pragma mark Configure Navigation Bar
- (void) configureNavigationBar {
    
    self.navigationController.viewControllers.count<=1?:[self addBackNavigationBarItem];
}

#pragma mark - Actions
#pragma mark -
#pragma mark Pop Action
- (void) popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

@end
