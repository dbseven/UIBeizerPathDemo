//
//  MLBaseCell.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell.h"
#import "MLBaseCell+Shaking.h"

@implementation MLBaseCell
#pragma mark - 构造方法
#pragma mark -
#pragma mark 工厂方法, 获取 TableView 中可复用的 Cell
+ (instancetype) cellInTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    
    MLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    
    if (!cell) {
        
        cell = [[self class] cellWithReuseIdentifier: reuseIdentifier];
    }
    
    return cell;
}

#pragma mark 工厂方法, 根据可复用标识符, 获取 Cell
+ (instancetype) cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    MLBaseCell *cell = [[[self class] alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: reuseIdentifier];
    return cell;
}

#pragma mark 工厂方法, 获取 TableView 中可复用的 Cell From Xib
+ (instancetype) cellInTableView:(UITableView *)tableView xibReuseIdentifier:(NSString *)reuseIdentifier {
    
    return [self cellInTableView: tableView
              xibReuseIdentifier: reuseIdentifier
                         atIndex: 0];
}

#pragma mark 工厂方法, 获取 TableView 中可复用的 Cell From Xib
+ (instancetype) cellInTableView:(UITableView *)tableView xibReuseIdentifier:(NSString *)reuseIdentifier atIndex:(NSInteger)index {
    
    MLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    
    if (!cell) {
        
        cell = [[self class] cellWithXibReuseIndentifier: reuseIdentifier atIndex: index];
    }
    
    return cell;
}

#pragma mark 工厂方法, 根据可复用标识符, 获取 Cell From Xib
+ (instancetype) cellWithXibReuseIndentifier:(NSString *)reuseIdentifier atIndex:(NSInteger)index {
    
    MLBaseCell *cell = [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class])
                                                     owner: nil
                                                    options: nil] objectAtIndex: index];
    return cell;
}

#pragma mark Init 方法
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        
        // 1. Member Variables
        _marginRight = kMLBaseCell_Margin_Right;
        _marginLeft = kMLBaseCell_Margin_Left;
        _marginTop = kMLBaseCell_Margin_Top;
        _marginBottom = kMLBaseCell_Margin_Bottom;
        
        // 2. Self
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 3. Register Notifications
        [self registerNotificationCenter];
        
        // 4. 默认设置 Shaking View
        self.shakingView = self.viewCellBackground;
        
        // 5. Setup UI
        [self setupUI];
    }
    
    return self;
}

#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy View Cell Background View
- (UIView *)viewCellBackground {
    
    if (!_viewCellBackground) {
        
        _viewCellBackground = [[UIView alloc] init];
        _viewCellBackground.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.64f];
        _viewCellBackground.clipsToBounds = NO;
        [self.contentView addSubview: _viewCellBackground];
    }
    
    return _viewCellBackground;
}

#pragma mark - 公有方法
#pragma mark -
#pragma mark Setup UI
- (void) setupUI {
    
}

#pragma mark Cell Height
+ (CGFloat) cellHeight {
    
    return 44;
}

@end
