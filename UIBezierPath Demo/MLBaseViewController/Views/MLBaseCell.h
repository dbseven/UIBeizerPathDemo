//
//  MLBaseCell.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** The default top margin */
static CGFloat const kMLBaseCell_Margin_Top = 5.0f;

/** The default bottom margin */
static CGFloat const kMLBaseCell_Margin_Bottom = 10.0;

/** The default left margin */
static CGFloat const kMLBaseCell_Margin_Left = 5.0f;

/** The default right margin */
static CGFloat const kMLBaseCell_Margin_Right = 5.0f;

@interface MLBaseCell : UITableViewCell
{
    /** Margin Top */
    CGFloat _marginTop;
    
    /** Margin Bottom */
    CGFloat _marginBottom;
    
    /** Margin Left */
    CGFloat _marginLeft;
    
    /** Margin Right */
    CGFloat _marginRight;
}


/**
 *  工厂方法, 获取 TableView 中可复用的 Cell
 *
 *  @param tableView 目标 TableView
 *  @param reuseIdentifier 可以复用 Cell 的标识符
 *
 *  @return  目标 TableView 中 可复用的 Cell
 */
+ (instancetype) cellInTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;


/**
 *  工厂方法, 根据可复用标识符, 获取 Cell
 *
 *  @param reuseIdentifier 可以复用 Cell 的标识符
 *
 *  @return  Cell 实例
 */
+ (instancetype) cellWithReuseIdentifier:(NSString *)reuseIdentifier;


/**
 *  工厂方法, 获取 TableView 中可复用的 Cell From Xib
 *
 *  @param tableView 目标 TableView
 *  @param reuseIdentifier 可以复用 Cell 的标识符
 *
 *  @return  目标 TableView 中 可复用的 Cell
 */
+ (instancetype) cellInTableView:(UITableView *)tableView xibReuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  工厂方法, 获取 TableView 中可复用的 Cell From Xib
 *
 *  @param tableView 目标 TableView
 *  @param reuseIdentifier 可以复用 Cell 的标识符
 *  @param atIndex The index of the xib in the file
 *
 *  @return  目标 TableView 中 可复用的 Cell
 */
+ (instancetype) cellInTableView:(UITableView *)tableView xibReuseIdentifier:(NSString *)reuseIdentifier atIndex:(NSInteger)index;

/**
 *  工厂方法, 根据可复用标识符, 获取 Cell From Xib
 *
 *  @param reuseIdentifier 可以复用 Cell 的标识符
 *  @param atIndex The index of the xib in the file
 *
 *  @return  Cell 实例
 */
+ (instancetype) cellWithXibReuseIndentifier:(NSString *)reuseIdentifier atIndex:(NSInteger)index;;


/** 背景 View */
@property (nonatomic, strong) UIView *viewCellBackground;


/**
 *  Setup UI: 子类实现
 */
- (void) setupUI;


/**
 *  Cell height
 *
 *  @return cell height;
 */
+ (CGFloat) cellHeight;

@end

NS_ASSUME_NONNULL_END