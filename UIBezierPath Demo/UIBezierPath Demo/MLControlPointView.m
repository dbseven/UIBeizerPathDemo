//
//  MLControlPointView.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/24.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLControlPointView.h"

/**
 *  控制点 Layer 高度
 */
static CGFloat const kMLControlPointLayer_PointHeight = 5;

/**
 *  控制点 Layer 宽度
 */
static CGFloat const kMLControlPointLayer_PointWidth = 5;

/**
 *  控制点 View 默认高度
 */
static CGFloat const kMLControlPointView_DefaultHeight = 20;

/**
 *  控制点 View 默认宽度
 */
static CGFloat const kMLControlPointView_DefaultWidth = 20;

@interface MLControlPointView ()
{
    /**
     *  控制点颜色
     */
    UIColor *_pointColor;
    
    /**
     *  脉冲颜色
     */
    UIColor *_pulseColor;
    
    /**
     *  移动起始点
     */
    CGPoint _beginPoint;
    
    /**
     *  触摸的起始点 与 Self Center 的偏移量
     */
    CGPoint _touchPointInset;
}

/**
 *  控制点 Layer
 */
@property (nonatomic, strong) CALayer *controlPointLayer;

/**
 *  动画 Layer
 */
@property (nonatomic, strong) CALayer *animationLayer;

/**
 *  控制点类型
 */
@property (nonatomic, assign) MLControlPointViewType type;

/**
 *  坐标点 Label
 */
@property (nonatomic, strong) UILabel *coordinateLabel;

/**
 *  删除按钮
 */
@property (nonatomic, strong) UIButton *removeButon;

@end

@implementation MLControlPointView
#pragma mark - Initialize Methods
#pragma mark -
#pragma mark Factory Method
+ (instancetype)controlPointViewWithPoint:(CGPoint)atPoint type:(MLControlPointViewType)type movedBlock:(nonnull MLControlPointViewMoved)moved coordinateLabelClickAction:(MLControlPointViewLabelClickAction)labelClickAction {
    
    MLControlPointView *controlPointView = [[MLControlPointView alloc] initAtPoint: atPoint
                                                                              type: type
                                                                        movedBlock: moved
                                                        coordinateLabelClickAction: labelClickAction];
    return controlPointView;
}

#pragma mark Init Method
- (instancetype)initAtPoint:(CGPoint)atPoint type:(MLControlPointViewType)type movedBlock:(nonnull MLControlPointViewMoved)moved coordinateLabelClickAction:(MLControlPointViewLabelClickAction)labelClickAction {
    
    if (self = [super init]) {
        
        // 0. Save Var
        self.controlPoint = atPoint;
        self.type = type;
        self.moved = moved;
        self.labelClickAction = labelClickAction;
        
        // 1. Configure UI
        [self configureUI];
        
        // 2. Begin Animation
        [self beginAnimation];
    }
    
    return self;
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Remove Button
- (UIButton *)removeButon {
    
    switch (self.type) {
        case MLControlPointViewTypeEndPoint:
        case MLControlPointViewTypeBeginPoint:
        {
            return nil;
        }
            break;
            
        default:
            break;
    }
    
    if (!_removeButon) {
        
        CGFloat buttonWidth = 10;
        CGFloat buttonHeight = 10;
        
        _removeButon = [UIButton buttonWithType: UIButtonTypeCustom];
        _removeButon.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight);
        _removeButon.center = CGPointMake(CGRectGetMaxX(_coordinateLabel.frame), CGRectGetMinY(_coordinateLabel.frame));
        _removeButon.titleLabel.font = [UIFont boldSystemFontOfSize: 6];
        _removeButon.layer.masksToBounds = YES;
        _removeButon.layer.cornerRadius = buttonWidth * 0.5f;
        _removeButon.layer.borderColor = [UIColor redColor].CGColor;
        _removeButon.layer.borderWidth = 1.0f;
        [_removeButon setTitle: @"❌" forState: UIControlStateNormal];
        [_removeButon setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
        [_removeButon addTarget: self action: @selector(removeButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _removeButon;
}

#pragma mark Lazy Control Point Layer
- (CALayer *)controlPointLayer {
    
    if (!_controlPointLayer) {
        
        _controlPointLayer = [CALayer layer];
        _controlPointLayer.backgroundColor = _pointColor.CGColor;
        _controlPointLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _controlPointLayer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        _controlPointLayer.bounds = CGRectMake(0, 0, kMLControlPointLayer_PointWidth, kMLControlPointLayer_PointHeight);
        _controlPointLayer.cornerRadius = kMLControlPointLayer_PointWidth * 0.5f;
    }
    
    return _controlPointLayer;
}

#pragma mark Lazy Animation Layer
- (CALayer *)animationLayer {
    
    if (!_animationLayer) {
        
        _animationLayer = [CALayer layer];
        _animationLayer.backgroundColor = _pulseColor.CGColor;
        _animationLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _animationLayer.bounds = CGRectMake(0, 0, kMLControlPointView_DefaultWidth, kMLControlPointView_DefaultHeight);
        _animationLayer.position = CGPointMake(kMLControlPointView_DefaultWidth*0.5, kMLControlPointView_DefaultHeight*0.5);
        _animationLayer.cornerRadius = kMLControlPointView_DefaultWidth * 0.5;
        [self.layer insertSublayer:_animationLayer below:_controlPointLayer];
    }
    
    return _animationLayer;
}

#pragma mark Lazy Coordinate Label
- (UILabel *)coordinateLabel {
    
    if (!_coordinateLabel) {
        
        CGFloat labelHeight = 20;
        CGFloat labelWidth = 40;
        
        _coordinateLabel = [[UILabel alloc] init];
        _coordinateLabel.center = CGPointMake(kMLControlPointView_DefaultWidth*0.5, labelHeight* (-0.5));
        _coordinateLabel.bounds = CGRectMake(0, 0, labelWidth, labelHeight);
        _coordinateLabel.backgroundColor = [UIColor darkGrayColor];
        _coordinateLabel.textColor = [UIColor whiteColor];
        _coordinateLabel.font = [UIFont boldSystemFontOfSize: 8];
        _coordinateLabel.textAlignment = NSTextAlignmentCenter;
        _coordinateLabel.clipsToBounds = NO;
        _coordinateLabel.numberOfLines = 2;
        _coordinateLabel.layer.masksToBounds = YES;
        _coordinateLabel.layer.cornerRadius = 4.0f;
        _coordinateLabel.alpha = 1.0f;
        [self addSubview: _coordinateLabel];
        [self addSubview: self.removeButon];
    }
    
    return _coordinateLabel;
}


#pragma mark - Override Set / Get Methods
#pragma mark -
#pragma mark Set Type
- (void)setType:(MLControlPointViewType)type {
    _type = type;
    
    switch (type) {
        case MLControlPointViewTypeControlPoint:
        {
            _pointColor = [UIColor blueColor];
            _pulseColor = [UIColor orangeColor];
        }
            break;
            
        case MLControlPointViewTypeEndPoint:
        {
            _pointColor = [UIColor redColor];
            _pulseColor = [UIColor orangeColor];
        }
            break;
            
        case MLControlPointViewTypeBeginPoint:
        {
            _pointColor = [UIColor greenColor];
            _pulseColor = [UIColor orangeColor];
        }
    }
}

#pragma mark - Override Metehods
#pragma mark -
#pragma mark Hit Test
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 1. 将 Point 转换到 Button 坐标系中
    CGPoint buttonPoint = [self convertPoint: point
                                      toView: self.removeButon];
    
    // 2. 判断点是否在 Button 中
    BOOL inButton = [self.removeButon pointInside: buttonPoint
                                   withEvent: event];
    if (inButton && (self.removeButon.alpha > 0.5f)) return self.removeButon;
    
    // 3. 将 Point 转换到 Label 坐标系中
    CGPoint labelPoint = [self convertPoint: point
                                     toView: self.coordinateLabel];
    
    // 4. 判断是否在 Label 中
    BOOL inLabel = [self.coordinateLabel pointInside: labelPoint
                                           withEvent: event];
    if (inLabel && (self.coordinateLabel.alpha > 0.5f)) {
        !self.labelClickAction?:self.labelClickAction(self);
        return self.coordinateLabel;
    }
    
    // 5. 返回父类结果
    return [super hitTest: point
                withEvent: event];
}

#pragma mark Touch Begin
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self controlPointLayerStateHightlight];
    
    // 1. 获取 Touch 对象
    UITouch *touch = [touches anyObject];
    
    // 2. 获取起始点
    _beginPoint = [touch locationInView: self.superview];
    
    // 3. 记录偏移量
    _touchPointInset = CGPointMake(self.center.x  - _beginPoint.x, self.center.y - _beginPoint.y);
    
    // 4. 设置 坐标 Label 文字
    [self configureCoordinateLabelText];
}

#pragma mark Touch Move
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 1. 获取 Touch 对象
    UITouch *touch = [touches anyObject];
    
    // 2. 获取触摸点
    CGPoint touchLocation = [touch locationInView: self.superview];
    
    // 3. 设置 Self 的 Center
    self.center = CGPointMake(touchLocation.x + _touchPointInset.x, touchLocation.y + _touchPointInset.y);
    
    // 4. 位置修补
    if (self.frame.origin.x < 0) {
        self.center = CGPointMake(kMLControlPointView_DefaultWidth*0.5, self.center.y);
    }
    if (self.frame.origin.y < 20) {
        self.center = CGPointMake(self.center.x, kMLControlPointView_DefaultHeight*0.5 + 20);
    }
    if (self.frame.origin.x + kMLControlPointView_DefaultWidth > kWidth_ScreenWidth) {
        self.center = CGPointMake(kWidth_ScreenWidth - kMLControlPointView_DefaultWidth * 0.5, self.center.y);
    }
    if (self.frame.origin.y + kMLControlPointView_DefaultHeight > kHeight_ScreenHeight) {
        self.center = CGPointMake(self.center.x, kHeight_ScreenHeight - kMLControlPointView_DefaultHeight * 0.5);
    }
    self.controlPoint = self.center;
    
    // 5. 回调 Block
    !self.moved?:self.moved();
    
    // 6. 设置 坐标 Label 文字
    [self configureCoordinateLabelText];
}

#pragma mark Touch End
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self controlPointLayerStateNormal];
}

#pragma mark Touch Cancel
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self controlPointLayerStateNormal];
}


#pragma mark - Actions 
#pragma mark -
- (void) removeButtonAction:(UIButton *)sender {
    !self.removeAction?:self.removeAction(self);
}


#pragma mark - Public Methods
#pragma mark -
#pragma mark 显示 Coordinate Label, 过 2s 后自动隐藏
- (void) showCoordinateLabelAndDelayHide {
    [self showCoordinateLabel];
    [self hideCoordinateLabel];
}

#pragma mark - Private Methods
#pragma mark -
#pragma mark Configure Coordinate Label Text
- (void) configureCoordinateLabelText {
    
    self.coordinateLabel.text = [NSString stringWithFormat: @"%.1f\n%.1f", self.center.x , self.center.y];
}

#pragma mark Control Point Layer State Normal
- (void) controlPointLayerStateNormal {
    
    _controlPointLayer.bounds = CGRectMake(0, 0, kMLControlPointLayer_PointWidth, kMLControlPointLayer_PointHeight);
    _controlPointLayer.cornerRadius = kMLControlPointLayer_PointWidth * 0.5f;
    [self hideCoordinateLabel];
}

#pragma mark Control Point Layer State Highlight
- (void) controlPointLayerStateHightlight {
    
    _controlPointLayer.bounds = CGRectMake(0, 0, kMLControlPointView_DefaultWidth, kMLControlPointView_DefaultHeight);
    _controlPointLayer.cornerRadius = kMLControlPointView_DefaultWidth * 0.5f;
    [self showCoordinateLabel];
}

#pragma mark Show Coordinate Label
- (void) showCoordinateLabel {
    
    [UIView animateWithDuration: 0.25f
                     animations:^{
                         self.coordinateLabel.alpha = 1.0f;
                         self.removeButon.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark Hide Coordinate Label
- (void) hideCoordinateLabel {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration: 0.64f
                         animations:^{
                             self.coordinateLabel.alpha = 0.0f;
                             self.removeButon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

#pragma mark Configure UI
- (void) configureUI {
    
    // 0. Configure Self
    self.bounds = CGRectMake(0, 0, kMLControlPointView_DefaultWidth, kMLControlPointView_DefaultHeight);
    self.center = self.controlPoint;
    
    // 1. Create Control Point Layer
    [self.layer addSublayer: self.controlPointLayer];
    
    // 2. 配置 Label 文字
    [self configureCoordinateLabelText];
    
    // 3. 隐藏 Label
    [self hideCoordinateLabel];
}

#pragma mark Begin Animation
- (void) beginAnimation {
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.fromValue = [NSNumber numberWithFloat: 0.2f];
    expandAnimation.toValue = [NSNumber numberWithFloat: 1.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat: 1.0f];
    opacityAnimation.toValue = [NSNumber numberWithFloat: 0.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[expandAnimation, opacityAnimation];
    groups.duration = 1.6f;
    groups.repeatCount = HUGE_VALF;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    [self.animationLayer addAnimation:groups forKey:@"group"];
}

@end
