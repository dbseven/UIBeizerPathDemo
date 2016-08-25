//
//  MLBaseCell.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell.h"

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
        
        // 4. Setup UI
        [self setupUI];
    }
    
    return self;
}

#pragma mark - 初始化方法
#pragma mark -
#pragma mark 注册通知
- (void) registerNotificationCenter {
    
    // 1. Shaking 开始
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(shakingBegin)
                                                 name: kMLNotificationName_Shaking_Begin
                                               object: nil];
    // 2. Shaking 结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(shakingEnd)
                                                 name: kMLNotificationName_Shaking_End
                                               object: nil];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy View Cell Background View
- (UIView *)viewCellBackground {
    
    if (!_viewCellBackground) {
        
        _viewCellBackground = [[UIView alloc] init];
        _viewCellBackground.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.64f];
        [self.contentView addSubview: _viewCellBackground];
    }
    
    return _viewCellBackground;
}


#pragma mark - 事件
#pragma mark -
#pragma mark 通知事件__震动开始
- (void) shakingBegin {
    _shaking = YES;
}

#pragma mark 通知事件__震动结束
- (void) shakingEnd {
    _shaking = NO;
}

#pragma mark - 公有方法
#pragma mark -
#pragma mark 点击后的震动效果
- (void) shake {
    
    if (_shaking) return;
    _shaking = YES;
    
    // 0. 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName: kMLNotificationName_Shaking_Begin
                                                        object: nil];
    
    // 1. 设置角度
    CGFloat angle = M_PI_4/32; // PI/4
    
    // 2. 动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(-angle), @(angle), @(-angle)];
    animation.duration = 0.16f;
    animation.repeatCount = 3;
    animation.delegate = self;
    
    // 3. 添加动画
    [self.viewCellBackground.layer addAnimation:animation forKey:nil];
}

#pragma mark Shaing 结束后, 调用这个方法, 子类需实现这个方法
- (void) shakingComplection {
    
}

#pragma mark Setup UI
- (void) setupUI {
    
}

#pragma mark Cell Height
+ (CGFloat) cellHeight {
    
    return 44;
}

#pragma mark - Animation Delegate
#pragma mark -
#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName: kMLNotificationName_Shaking_End
                                                        object: nil];
    
    // Shaking 结束
    [self shakingComplection];
}

@end
