//
//  MLSpringView.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/29.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLSpringView.h"
#import "MLControlPointView.h"

@interface MLSpringView ()
{
    BOOL _isAnimating;
    
    CGRect _contentViewFrame;
    
    CGFloat _contentViewHeightOffset;
}
/**
 *  左侧控制点
 */
@property (nonatomic, strong) MLControlPointView *leftControlPoint;

/**
 *  右侧控制点
 */
@property (nonatomic, strong) MLControlPointView *middleControlPoint;

/**
 *  Display Link
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  Bezier Path
 */
@property (nonatomic, strong) UIBezierPath *bezierPath;

/**
 *  Shape Layer
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation MLSpringView
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Factory Methods
+ (instancetype) springViewWithContentViewFrame:(CGRect)frame; {
    
    MLSpringView *springView = [[MLSpringView alloc] initWithFrame: [UIScreen mainScreen].bounds
                                                  contentViewFrame: frame];
    return springView;
}

#pragma mark Init
- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark Init With Frame
- (instancetype) initWithFrame:(CGRect)frame contentViewFrame:(CGRect)contentViewFrame {
    
    if (self = [super initWithFrame: frame]) {
        
        // 0. Vars
        _contentViewHeightOffset = 40;
        _contentViewFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, contentViewFrame.size.width, contentViewFrame.size.height + _contentViewHeightOffset);
        
        // 1. Configure UI
        [self configureUI];
    }
    
    return self;
}

#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark Configure UI
- (void) configureUI {
    
    // 1. Self
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0f];
    self.userInteractionEnabled = NO;
    
    // 2. Content View
    [self addSubview: self.contentView];
    
    // 2. Control Points
    [self.contentView addSubview: self.leftControlPoint];
    [self.contentView addSubview: self.middleControlPoint];
    
    NSInteger buttonCount = 6;
    NSInteger buttonPreLine = 3;
    NSInteger lineCount = buttonCount % buttonPreLine == 0 ? buttonCount / buttonPreLine : buttonCount / buttonPreLine + 1;
    NSInteger margin = 10;
    CGFloat width = (_contentViewFrame.size.width - ((buttonPreLine+1) * margin)) / buttonPreLine;
    CGFloat height = (_contentViewFrame.size.height - _contentViewHeightOffset - ((buttonPreLine+1) * margin)) / lineCount;
    
    for (NSInteger index=0; index<buttonCount; index++) {
        
        NSInteger colum = index % buttonPreLine;
        NSInteger line = index / buttonPreLine;
        
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake((colum+1)*margin + colum*width, (line+1)*margin + line*height + _contentViewHeightOffset, width, height);
        [button setBackgroundColor: [UIColor greenColor]];
        [button setTitle: [NSString stringWithFormat:@"B%d", index+1] forState: UIControlStateNormal];
        [self.contentView addSubview: button];
    }
}


#pragma mark - Override Methods
#pragma mark -
#pragma mark Touch End
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Content View
- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame: _contentViewFrame];
        _contentView.backgroundColor = [UIColor orangeColor];
    }
    
    return _contentView;
}

#pragma mark Lazy Shape Layer
- (CAShapeLayer *)shapeLayer {
    
    if (!_shapeLayer) {
        
        _shapeLayer = [CAShapeLayer layer];
    }
    
    return _shapeLayer;
}

#pragma mark Lazy Bezier Path
- (UIBezierPath *)bezierPath {
    
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
    }
    
    return _bezierPath;
}

#pragma mark Lazy Display Link
- (CADisplayLink *)displayLink {
    
    if (!_displayLink) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget: self
                                                   selector: @selector(displayLinkAction:)];
        [_displayLink addToRunLoop: [NSRunLoop currentRunLoop]
                           forMode: NSRunLoopCommonModes];
    }
    
    return _displayLink;
}

#pragma mark Lazy Left Control Point
- (MLControlPointView *)leftControlPoint {
    
    if (!_leftControlPoint) {
        _leftControlPoint = [MLControlPointView controlPointViewWithPoint: CGPointMake(0, _contentViewFrame.size.height)
                                                                     type: MLControlPointViewTypeEndPoint
                                                               movedBlock:^{
                                                                   
                                                               }
                                               coordinateLabelClickAction:^(MLControlPointView * _Nonnull controlPointView) {
                                                   
                                               }];
        _leftControlPoint.userInteractionEnabled = NO;
    }
    
    return _leftControlPoint;
}

#pragma mark Lazy Right Control Point
- (MLControlPointView *)middleControlPoint {
    
    if (!_middleControlPoint) {
        _middleControlPoint = [MLControlPointView controlPointViewWithPoint: CGPointMake(self.frame.size.width*0.5, _contentViewFrame.size.height)
                                                                     type: MLControlPointViewTypeEndPoint
                                                               movedBlock:^{
                                                                   
                                                               }
                                               coordinateLabelClickAction:^(MLControlPointView * _Nonnull controlPointView) {
                                                   
                                               }];
        _middleControlPoint.userInteractionEnabled = NO;
    }
    
    return _middleControlPoint;
}

#pragma mark - Public Methods
#pragma mark -
#pragma mark Show
- (void) show {
    
    // 0. Whether can begin animation
    if (_isAnimating) return;
    _isAnimating = YES;
    
    // 1. Self
    [UIView animateWithDuration: 0.25
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.32];
                     }];
    self.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _contentViewFrame.size.height, _contentViewFrame.size.width, _contentViewFrame.size.height);
    [self configBezierPath];
    
    // 2. Display Link Begin
    self.displayLink.paused = NO;
    
    // 3. Control Point Animation
    [UIView animateWithDuration: 1.0
                          delay: 0.0f
         usingSpringWithDamping: 1
          initialSpringVelocity: 10
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.leftControlPoint.center = CGPointMake(0, _contentViewHeightOffset);
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration: 1.0
                          delay: 0.0f
         usingSpringWithDamping: 0.64
          initialSpringVelocity: 1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.middleControlPoint.center = CGPointMake(self.middleControlPoint.center.x, _contentViewHeightOffset);
                     } completion:^(BOOL finished) {
                         self.displayLink.paused = YES;
                         _isAnimating = NO;
                         self.userInteractionEnabled = YES;
                     }];
}

#pragma mark Hide
- (void) hide {
    
    self.displayLink.paused = NO;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration: 0.25
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0];
                     }];
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.leftControlPoint.center = CGPointMake(0, _contentViewHeightOffset - 20);
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration: 0.16
                          delay: 0.25
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.leftControlPoint.center = CGPointMake(0, _contentViewFrame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration: 0.16
                          delay: 0.30
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.middleControlPoint.center = CGPointMake(self.middleControlPoint.center.x, _contentViewFrame.size.height);
                     } completion:^(BOOL finished) {
                         self.displayLink.paused = YES;
                         _isAnimating = NO;
                     }];
}


#pragma mark - Private Methods
#pragma mark -
#pragma mark Config Bezier Path
- (void) configBezierPath {
    
    // 0. Vars
    CALayer *middelLayer = [self.middleControlPoint.layer presentationLayer];
    CALayer *leftLayer = [self.leftControlPoint.layer presentationLayer];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 1.
    [self.bezierPath removeAllPoints];
    
    [self.bezierPath moveToPoint: leftLayer.position];
    [self.bezierPath addQuadCurveToPoint: CGPointMake(self.frame.size.width, leftLayer.position.y)
                            controlPoint: middelLayer.position];
    [self.bezierPath addLineToPoint: CGPointMake(width, height)];
    [self.bezierPath addLineToPoint: CGPointMake(0, height)];
    [self.bezierPath closePath];
    
    self.shapeLayer.path = self.bezierPath.CGPath;
    self.contentView.layer.mask = self.shapeLayer;
}


#pragma mark - Action Methods
#pragma mark -
#pragma mark Display Link Action
- (void) displayLinkAction:(CADisplayLink *) displayLink {
    
    [self configBezierPath];
}


#pragma mark - Override Get / Set Methods
#pragma mark -
#pragma mark Set Display Type
- (void)setDisplayType:(MLSpringViewDisplayType)displayType {
    
    switch (displayType) {
        case MLSpringViewDisplayTypeNormal:
        {
            self.contentView.backgroundColor = [UIColor orangeColor];
            self.leftControlPoint.hidden = YES;
            self.middleControlPoint.hidden = YES;
        }
            break;
            
        case MLSpringViewDisplayTypeSkeleton:
        {
            self.contentView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent: 0.32f];
            self.leftControlPoint.hidden = NO;
            self.middleControlPoint.hidden = NO;
        }
            break;
    }
}

@end
