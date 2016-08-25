//
//  MLBaseCell+Shaking.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell+Shaking.h"
#import <objc/message.h>

static NSString *const kMLShakingCell_Animation_UniqueKey = @"kMLShakingCell_Animation_UniqueKey";

static void *ShakingFlagKey = &ShakingFlagKey;
static void *ShakingViewKey = &ShakingViewKey;
static void *ShakingOverKey = &ShakingOverKey;

@implementation MLBaseCell (Shaking)
#pragma mark - Public Methods
#pragma mark -
#pragma mark 点击后的震动效果
- (BOOL) shake {
    
    if (self.isShaking) return NO;
    self.shaking = YES;
    
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
    [animation setValue: kMLShakingCell_Animation_UniqueKey forKey: kMLShakingCell_Animation_UniqueKey];
    
    // 3. 添加动画
    [self.shakingView.layer addAnimation:animation forKey: nil];
    
    return YES;
}

#pragma mark Shaing 结束后, 调用这个方法, 子类需实现这个方法
- (void) shakingComplection {
    
}


#pragma mark 注册 Shaking 相关的通知
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


#pragma mark - Override Set / Get Methods
#pragma mark -
#pragma mark Set Shaking
- (void) setShaking:(BOOL)shaking {
    objc_setAssociatedObject(self, ShakingFlagKey, @(shaking), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark Get Shaking
- (BOOL) isShaking {
    return [objc_getAssociatedObject(self, ShakingFlagKey) boolValue];
}

#pragma mark Set Shaking View
- (void) setShakingView:(UIView *)shakingView {
    objc_setAssociatedObject(self, ShakingViewKey, shakingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Get Shaking View
- (UIView *) shakingView {
    return objc_getAssociatedObject(self, ShakingViewKey);
}

#pragma mark Set Shaking Over Block
- (void) setShakingOver:(MLShakingOver)shakingOver {
    objc_setAssociatedObject(self, ShakingOverKey, shakingOver, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark Get Shaking Over Block
- (MLShakingOver) shakingOver {
    return objc_getAssociatedObject(self, ShakingOverKey);

}

#pragma mark - Actions
#pragma mark -
#pragma mark 通知事件__震动开始
- (void) shakingBegin {
    self.shaking = YES;
}

#pragma mark 通知事件__震动结束
- (void) shakingEnd {
    self.shaking = NO;
}


#pragma mark - Animation Delegate
#pragma mark -
#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (![anim valueForKey: kMLShakingCell_Animation_UniqueKey]) {
        [self ml_animationDidStop: anim
                         finished: flag];
        return;
    }
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName: kMLNotificationName_Shaking_End
                                                        object: nil];
    
    // Shaking 结束
    !self.shakingOver?:self.shakingOver();
}

@end
