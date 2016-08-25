//
//  MLHomePageCell.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomePageCell.h"
#import "MLBaseCell+Shaking.h"
#import "MLViewControllerJumpModel.h"

@interface MLHomePageCell ()
{
    CGFloat _r;
    
    BOOL _isAnimating;
}

/**
 *  标题 Label
 */
@property (nonatomic, strong) UILabel *ml_titleLabel;

/**
 *  动画 ImageView
 */
@property (nonatomic, strong) UIImageView *ml_animationImageView_first;

/**
 *  动画 ImageView
 */
@property (nonatomic, strong) UIImageView *ml_animationImageView_second;

@property (nonatomic, strong) CAKeyframeAnimation *keyFrameAnimation_first;

@property (nonatomic, strong) CAKeyframeAnimation *keyFrameAnimation_second;

@property (nonatomic, strong) UIBezierPath *bezierPath_first;

@property (nonatomic, strong) UIBezierPath *bezierPath_second;

@property (nonatomic, strong) UIView *tempView;

@end

@implementation MLHomePageCell
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self.ml_animationImageView_first.layer removeAllAnimations];
    [self.ml_animationImageView_second.layer removeAllAnimations];
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark <#Method Name#>

#pragma mark - Override Methods
#pragma mark -
#pragma mark Setup UI
- (void) setupUI {
    
    // 0. 半径 和 注册通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopAnimation)
                                                 name: @"ml_stopAnimation"
                                               object: nil];
    _r = 20;
    
    // 1. Self
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 2. Setup Cell Background View
    [self setupCellBackgroundView];
    
    // 3. 设置 Shaking View
    self.shakingView = self.viewCellBackground;
    
    // 4. 设置 Shaking 回调
    __weak __typeof(&*self)weakSelf = self;
    self.shakingOver = ^(){
        !weakSelf.didClick?:weakSelf.didClick(weakSelf, weakSelf.jumpModel);
    };
}

#pragma mark Prepare Reuse
- (void) prepareForReuse {
    
    [super prepareForReuse];
    
    // 1. Setup Cell Background View
    [self setupCellBackgroundView];
}

#pragma mark Cell Height
+ (CGFloat)cellHeight {
    return 64;
}


#pragma mark - Override Set / Get Methods
#pragma mark -
#pragma mark Set Jump Model
- (void) setJumpModel:(MLViewControllerJumpModel *)jumpModel {
    
    _jumpModel = jumpModel;
    
    // Animation
    if (jumpModel.isSelected) {
        [self beginAnimation];
    } else {
        [self stopAnimation];
    }
    
    // Set Title
    self.ml_titleLabel.text = jumpModel.title;
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy BezierPath First
- (UIBezierPath *) bezierPath_first {
    
    if (!_bezierPath_first) {
        
        CGRect rect = self.viewCellBackground.frame;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        
        _bezierPath_first = [UIBezierPath bezierPath];
        [_bezierPath_first moveToPoint: CGPointMake(width - _r, 0)];
        [_bezierPath_first addArcWithCenter: CGPointMake(width - _r, _r)
                        radius: _r
                    startAngle: 1.5 * M_PI
                      endAngle: 2 * M_PI
                     clockwise: YES];
        [_bezierPath_first addLineToPoint: CGPointMake(width, height)];
        [_bezierPath_first addLineToPoint: CGPointMake(_r, height)];
        [_bezierPath_first addArcWithCenter: CGPointMake(_r, height - _r)
                        radius: _r
                    startAngle: 0.5 * M_PI
                      endAngle: M_PI
                     clockwise: YES];
        [_bezierPath_first addLineToPoint: CGPointMake(0, 0)];
        [_bezierPath_first addLineToPoint: CGPointMake(width - _r, 0)];
    }
    
    return _bezierPath_first;
}

#pragma mark Lazy BezierPath Second
- (UIBezierPath *) bezierPath_second {
    
    if (!_bezierPath_second) {
        
        CGRect rect = self.viewCellBackground.frame;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        
        _bezierPath_second = [UIBezierPath bezierPath];
        [_bezierPath_second moveToPoint: CGPointMake(_r, height)];
        [_bezierPath_second addArcWithCenter: CGPointMake(_r, height - _r)
                                     radius: _r
                                 startAngle: 0.5 * M_PI
                                   endAngle: M_PI
                                  clockwise: YES];
        [_bezierPath_second addLineToPoint: CGPointMake(0, 0)];
        [_bezierPath_second addLineToPoint: CGPointMake(width - _r, 0)];
        [_bezierPath_second addArcWithCenter: CGPointMake(width - _r, _r)
                                      radius: _r
                                  startAngle: 1.5 * M_PI
                                    endAngle: 2 * M_PI
                                   clockwise: YES];
        [_bezierPath_second addLineToPoint: CGPointMake(width, height)];
        [_bezierPath_second addLineToPoint: CGPointMake(_r, height)];
    }
    
    return _bezierPath_second;
}

#pragma mark Lazy KeyFrameAnimation First
- (CAKeyframeAnimation *)keyFrameAnimation_first {
    
    if (!_keyFrameAnimation_first) {
        
        CGFloat lineH = [UIScreen mainScreen].bounds.size.width - _marginLeft - _marginRight - _r;
        CGFloat arc = (90.0 * _r * M_PI) / 180.0; // (圆角 * 半径 * π) / 180.0°;
        CGFloat lineV = [[self class] cellHeight] - _marginTop - _marginBottom - _r;
        CGFloat distance = lineH * 2 + arc * 2 + lineV * 2;
        
        CGFloat time1 = arc / distance;
        CGFloat time2 = (lineV + arc) / distance;
        CGFloat time3 = (lineH + lineV + arc) / distance;
        CGFloat time4 = (lineH + lineV + arc*2) / distance;
        CGFloat time5 = (lineH + lineV*2 + arc*2) / distance;
        
        _keyFrameAnimation_first = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        _keyFrameAnimation_first.removedOnCompletion = NO;
        _keyFrameAnimation_first.fillMode = kCAFillModeForwards;
        _keyFrameAnimation_first.path = self.bezierPath_first.CGPath;
        _keyFrameAnimation_first.keyTimes = @[@(0.0), @(0.0), @(time1), @(time2), @(time3), @(time3), @(time4), @(time5), @(1.0)];
        _keyFrameAnimation_first.duration = 6.4f;
        _keyFrameAnimation_first.repeatCount = HUGE_VALF;
    }
    
    return _keyFrameAnimation_first;
}

#pragma mark Lazy KeyFrameAnimation Second
- (CAKeyframeAnimation *)keyFrameAnimation_second {
    
    if (!_keyFrameAnimation_second) {
        
        CGFloat lineH = [UIScreen mainScreen].bounds.size.width - _marginLeft - _marginRight - _r;
        CGFloat arc = (90.0 * _r * M_PI) / 180.0; // (圆角 * 半径 * π) / 180.0°;
        CGFloat lineV = [[self class] cellHeight] - _marginTop - _marginBottom - _r;
        CGFloat distance = lineH * 2 + arc * 2 + lineV * 2;
        
        CGFloat time1 = arc / distance;
        CGFloat time2 = (lineV + arc) / distance;
        CGFloat time3 = (lineH + lineV + arc) / distance;
        CGFloat time4 = (lineH + lineV + arc*2) / distance;
        CGFloat time5 = (lineH + lineV*2 + arc*2) / distance;
        
        _keyFrameAnimation_second = [CAKeyframeAnimation animationWithKeyPath: @"position"];
        _keyFrameAnimation_second.path = self.bezierPath_second.CGPath;
        _keyFrameAnimation_second.keyTimes = @[@(0.0), @(0.0), @(time1), @(time2), @(time3), @(time3), @(time4), @(time5), @(1.0)];
        _keyFrameAnimation_second.duration = 6.4f;
        _keyFrameAnimation_second.repeatCount = HUGE_VALF;
    }
    
    return _keyFrameAnimation_second;
}

#pragma mark Lazy ml_animationImageView_first
- (UIImageView *) ml_animationImageView_first {
    
    if (!_ml_animationImageView_first) {
        
        CGFloat imageWidth = 64;
        CGFloat imageHeight = 64;
        _ml_animationImageView_first = [[UIImageView alloc] init];
        _ml_animationImageView_first.frame = CGRectMake(imageWidth*0.5, imageHeight*0.5, imageWidth, imageHeight);
        _ml_animationImageView_first.animationImages = @[
                                                         [UIImage imageNamed: @"Comp 1_00000"],
                                                         [UIImage imageNamed: @"Comp 1_00001"],
                                                         [UIImage imageNamed: @"Comp 1_00002"],
                                                         [UIImage imageNamed: @"Comp 1_00003"],
                                                         [UIImage imageNamed: @"Comp 1_00004"],
                                                         [UIImage imageNamed: @"Comp 1_00005"],
                                                         [UIImage imageNamed: @"Comp 1_00006"],
                                                         [UIImage imageNamed: @"Comp 1_00007"],
                                                         [UIImage imageNamed: @"Comp 1_00008"],
                                                         [UIImage imageNamed: @"Comp 1_00009"]
                                                         ];
        _ml_animationImageView_first.animationDuration = _ml_animationImageView_first.animationImages.count / 20;
        _ml_animationImageView_first.animationRepeatCount = HUGE_VALF;
        [self.tempView addSubview: _ml_animationImageView_first];
    }
    
    return _ml_animationImageView_first;
}

#pragma mark Lazy ml_animationImageView_second
- (UIImageView *) ml_animationImageView_second {
    
    if (!_ml_animationImageView_second) {
        
        CGFloat imageWidth = 64;
        CGFloat imageHeight = 64;
        _ml_animationImageView_second = [[UIImageView alloc] init];
        _ml_animationImageView_second.frame = CGRectMake(imageWidth*0.5, imageHeight*0.5, imageWidth, imageHeight);
        _ml_animationImageView_second.animationImages = @[
                                                         [UIImage imageNamed: @"Comp 1_00000"],
                                                         [UIImage imageNamed: @"Comp 1_00001"],
                                                         [UIImage imageNamed: @"Comp 1_00002"],
                                                         [UIImage imageNamed: @"Comp 1_00003"],
                                                         [UIImage imageNamed: @"Comp 1_00004"],
                                                         [UIImage imageNamed: @"Comp 1_00005"],
                                                         [UIImage imageNamed: @"Comp 1_00006"],
                                                         [UIImage imageNamed: @"Comp 1_00007"],
                                                         [UIImage imageNamed: @"Comp 1_00008"],
                                                         [UIImage imageNamed: @"Comp 1_00009"]
                                                         ];
        _ml_animationImageView_second.animationDuration = _ml_animationImageView_second.animationImages.count / 20;
        _ml_animationImageView_second.animationRepeatCount = HUGE_VALF;
        [self.tempView addSubview: _ml_animationImageView_second];
    }
    
    return _ml_animationImageView_second;
}

#pragma mark Lazy Temp View
- (UIView *)tempView {
    
    if (!_tempView) {
        
        _tempView = [[UIView alloc] initWithFrame: self.viewCellBackground.frame];
        _tempView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: _tempView];
    }
    
    return _tempView;
}

#pragma mark Lazy ml_titleLabel
- (UILabel *) ml_titleLabel {
    
    if (!_ml_titleLabel) {
        
        _ml_titleLabel = [[UILabel alloc] init];
        _ml_titleLabel.frame = CGRectMake(10, 5, self.viewCellBackground.frame.size.width - 20, self.viewCellBackground.frame.size.height - 10);
        _ml_titleLabel.font = [UIFont boldSystemFontOfSize: 16];
        _ml_titleLabel.textColor = [UIColor blackColor];
        [self.viewCellBackground addSubview: _ml_titleLabel];
    }
    
    return _ml_titleLabel;
}


#pragma mark - Public Methods
#pragma mark -
#pragma mark Begin Animation
- (void) beginAnimation {
    
    // 1. 判断是否需要开启动画
    
    // 2. 发送通知, 取消其他动画
    [[NSNotificationCenter defaultCenter] postNotificationName: @"ml_stopAnimation"
                                                        object: nil];
    
    // 2. 设置选中模式
    self.jumpModel.selected = YES;
    
    // 3. 添加动画
    [self.ml_animationImageView_first.layer  addAnimation: self.keyFrameAnimation_first
                                                   forKey: @"ml_animationImageView_first"];
    [self.ml_animationImageView_second.layer addAnimation: self.keyFrameAnimation_second
                                                   forKey: @"ml_animationImageView_second"];
    [self.ml_animationImageView_first startAnimating];
    [self.ml_animationImageView_second startAnimating];
    
    // 4. 开始动画
    self.ml_animationImageView_first.alpha = 1.0;
    self.ml_animationImageView_second.alpha = 1.0;
}

#pragma mark Stop Animation
- (void) stopAnimation {
    
    self.ml_animationImageView_first.alpha = 0.0f;
    self.ml_animationImageView_second.alpha = 0.0f;
    [self.ml_animationImageView_first.layer removeAllAnimations];
    [self.ml_animationImageView_second.layer removeAllAnimations];
    [self.ml_animationImageView_first stopAnimating];
    [self.ml_animationImageView_second stopAnimating];
}

#pragma mark Setup Cell Background View
- (void) setupCellBackgroundView {
    
    // 0. BackgroundView
    if (!self.viewCellBackground.layer.mask) {
        self.viewCellBackground.frame = CGRectMake(_marginLeft, _marginTop, [UIScreen mainScreen].bounds.size.width - _marginRight - _marginLeft, [[self class] cellHeight] - _marginBottom);
        
        // 1. CAShapeLayer
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = self.bezierPath_first.CGPath;
        
        // 2.
        self.viewCellBackground.layer.mask = shapeLayer;
    }
}

@end



