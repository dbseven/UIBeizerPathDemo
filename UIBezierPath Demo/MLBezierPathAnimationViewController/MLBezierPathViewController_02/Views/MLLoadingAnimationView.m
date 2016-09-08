//
//  MLLoadingAnimationView.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/9/8.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLLoadingAnimationView.h"

static NSString *const kMLAnimationNameKey = @"kMLAnimationName";

@interface MLLoadingAnimationView ()
{
    /**
     *  Stroke Start
     */
    CGFloat _strokeStart;
    
    /**
     *  Stroke End
     */
    CGFloat _strokeEnd;
    
    /**
     *  In the first part of animation, this variate will Increment by 0.01, in the second part of animatin, this variate will Decrement by 0.01. default is 0.01;
     */
    CGFloat _animationSpeedOffset;
}

/**
 *  Animation Layer
 */
@property (nonatomic, strong) CAShapeLayer *animationLayer;

@end

@implementation MLLoadingAnimationView
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Factory Method
+ (instancetype) loadingAnimationViewWithFrame:(CGRect)frame {
    
    MLLoadingAnimationView *animationView = [[MLLoadingAnimationView alloc] initWithFrame: frame];
    return animationView;
}

#pragma mark Init
- (instancetype)init {
    
    if (self = [super init]) {
        
        // 0. Config Basic Var
        [self configBasicVar];
        
        // 1. Setup UI
        [self configUI];
    }
    
    return self;
}

#pragma mark Init With Frame
- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame: frame]) {
        
        // 0. Config Basic Var
        [self configBasicVar];
        
        // 1. Setup UI
        [self configUI];
    }
    
    return self;
}

#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark Config Basic Var
- (void) configBasicVar {
    
    // 1. Stroke Start
    _strokeStart = 0.05;
    
    // 2. Stroke End
    _strokeEnd = 0.05;
    
    // 3. Speed Offset
    _animationSpeedOffset = 0.01;
}

#pragma mark Config UI
- (void) configUI {
    
    // 1. Background Color
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.64f];
    
    // 2. Config BezierPath
    [self configBezierPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginLoading];
    });
}

#pragma mark Config Bezier Path
- (void) configBezierPath {
    
    // 1. Create BezierPath
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter: CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5)
                                                              radius: self.frame.size.width*0.5 - 10
                                                          startAngle: -M_PI * 0.5
                                                            endAngle: M_PI * 1.5
                                                           clockwise: YES];
    
    // 2.
    self.animationLayer.path = bezierPath.CGPath;
}


#pragma mark - Override Methods
#pragma mark -


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Animation Layer
- (CAShapeLayer *)animationLayer {
    
    if (!_animationLayer) {
        
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.bounds = self.bounds;
        _animationLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _animationLayer.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        _animationLayer.strokeColor = [UIColor redColor].CGColor;
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.lineWidth = 4;
        _animationLayer.lineCap = kCALineCapRound;
        _animationLayer.strokeStart = _strokeStart;
        _animationLayer.strokeEnd = _strokeEnd;
        [self.layer addSublayer: _animationLayer];
    }
    
    return _animationLayer;
}


#pragma mark - Public Methods
#pragma mark -
#pragma mark Begin Loading Animation
- (void)beginLoading {
    [self rotationAnimation];
}

#pragma mark Stop Loading Animation
- (void)stopLoading {
}


#pragma mark - Private Methods
#pragma mark -

#pragma mark Update Shape
- (void) updateShape {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration: 0.0];
    self.animationLayer.strokeStart = _strokeStart;
    self.animationLayer.strokeEnd = _strokeEnd;
    [CATransaction commit];
}

#pragma mark Rotation Animation
- (void) rotationAnimation {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 1.64;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [_animationLayer addAnimation: rotationAnimation forKey: @"rotationAnimation"];
    
    [self strokeEndAnimation];
}

#pragma mark Stroke End Animation
- (void) strokeEndAnimation {
    
    self.animationLayer.strokeStart = 0.05;
    self.animationLayer.strokeEnd = 1.0f;
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.05);
    strokeEndAnimation.duration = 0.84f;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    strokeEndAnimation.delegate = self;
    [strokeEndAnimation setValue: @"strokeEndAnimation" forKey: kMLAnimationNameKey];
    [_animationLayer addAnimation: strokeEndAnimation forKey: @"strokeEndAnimation"];
}

#pragma mark Stroke Start Animation
- (void) strokeStartAnimation {
    
    self.animationLayer.strokeStart = 1.0;
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath: @"strokeStart"];
    strokeEndAnimation.fromValue = @(0.05);
    strokeEndAnimation.duration = 0.84f;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    strokeEndAnimation.delegate = self;
    [strokeEndAnimation setValue: @"strokeStartAnimation" forKey: kMLAnimationNameKey];
    [_animationLayer addAnimation: strokeEndAnimation forKey: @"strokeEndAnimation"];
}

#pragma mark - CAAnimation Delegate
#pragma mark -
#pragma mark Animation Stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSString *name = [anim valueForKey: kMLAnimationNameKey];
    
    if ([name isEqualToString: @"strokeEndAnimation"]) {
        
        [self strokeStartAnimation];
    } else if([name isEqualToString: @"strokeStartAnimation"]) {
        
        [self strokeEndAnimation];
    }
}


#pragma mark - Action Methods
#pragma mark -


#pragma mark - ViewController Switch Methods
#pragma mark -
#pragma mark <#Method Name#>

@end
