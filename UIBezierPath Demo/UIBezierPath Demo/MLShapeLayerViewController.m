//
//  MLShapeLayerViewController.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/24.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLShapeLayerViewController.h"
#import "MLControlPointView.h"

@interface MLShapeLayerViewController ()

/** 开始点到控制点的虚线 Shape Layer */
@property (nonatomic, strong) CAShapeLayer *dashedLineShapeLayer_BeginPoint;

/** 结束点到控制点的虚线 Shape Layer */
@property (nonatomic, strong) CAShapeLayer *dashedLineShapeLayer_EndPoint;

/** 开始点到控制点的贝塞尔曲线 */
@property (nonatomic, strong) UIBezierPath *dashedLineBezierPath_BeginPoint;

/** 结束点到控制点的贝塞尔曲线 */
@property (nonatomic, strong) UIBezierPath *dashedLineBezierPath_EndPoint;

/** Shape Layer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/** Bezier Path */
@property (nonatomic, strong) UIBezierPath *bezierPath;

/** Begin Point */
@property (nonatomic, strong) MLControlPointView *beginPoint;

/** End Point */
@property (nonatomic, strong) MLControlPointView *endPoint;

/** Control Pointes */
@property (nonatomic, strong) NSMutableArray<MLControlPointView *> *controlPoints;

/** Add Button */
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation MLShapeLayerViewController
#pragma mark - ViewController Life Circle
#pragma mark -
#pragma mark View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Configure UI
    [self configureUI];
    
    // 2. Configure Bezier Path
    [self configureBezierPath];
}


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Dash Line Bezier Path To Begin Point
- (UIBezierPath *)dashedLineBezierPath_BeginPoint {
    
    if (!_dashedLineBezierPath_BeginPoint) {
        
        _dashedLineBezierPath_BeginPoint = [UIBezierPath bezierPath];
    }
    
    return _dashedLineBezierPath_BeginPoint;
}

#pragma mark Lazy Dash Line Bezier Path To End Point
- (UIBezierPath *)dashedLineBezierPath_EndPoint {
    
    if (!_dashedLineBezierPath_EndPoint) {
        
        _dashedLineBezierPath_EndPoint = [UIBezierPath bezierPath];
    }
    
    return _dashedLineBezierPath_EndPoint;
}

#pragma mark Lazy Dash Line Shape Layer To Begin Point
- (CAShapeLayer *)dashedLineShapeLayer_BeginPoint {
    
    if (!_dashedLineShapeLayer_BeginPoint) {
        
        _dashedLineShapeLayer_BeginPoint = [CAShapeLayer layer];
        _dashedLineShapeLayer_BeginPoint.fillColor = [UIColor clearColor].CGColor;
        _dashedLineShapeLayer_BeginPoint.strokeColor = [UIColor darkGrayColor].CGColor;
        _dashedLineShapeLayer_BeginPoint.lineWidth = 0.5f;
        _dashedLineShapeLayer_BeginPoint.lineDashPattern = @[@(4), @(2)];
        [self.view.layer insertSublayer: _dashedLineShapeLayer_BeginPoint
                                  below: _shapeLayer];
    }
    
    return _dashedLineShapeLayer_BeginPoint;
}

#pragma mark Lazy Dash Line Shape Layer To End Point
- (CAShapeLayer *)dashedLineShapeLayer_EndPoint {
    
    if (!_dashedLineShapeLayer_EndPoint) {
        
        _dashedLineShapeLayer_EndPoint = [CAShapeLayer layer];
        _dashedLineShapeLayer_EndPoint.fillColor = [UIColor clearColor].CGColor;
        _dashedLineShapeLayer_EndPoint.strokeColor = [UIColor darkGrayColor].CGColor;
        _dashedLineShapeLayer_EndPoint.lineWidth = 0.5f;
        _dashedLineShapeLayer_EndPoint.lineDashPattern = @[@(4), @(4)];
        [self.view.layer insertSublayer: _dashedLineShapeLayer_EndPoint
                                  below: _shapeLayer];
    }
    
    return _dashedLineShapeLayer_EndPoint;
}


#pragma mark Lazy Add Button
- (UIButton *) addButton {
    
    if (!_addButton) {
        
        _addButton = [UIButton buttonWithType: UIButtonTypeContactAdd];
        _addButton.center = CGPointMake(kWidth_ScreenWidth - 44, kHeight_ScreenHeight - 44);
        [_addButton addTarget: self action: @selector(addControlPointAction:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

#pragma mark Lazy Control Points
- (NSMutableArray<MLControlPointView *> *)controlPoints {
    
    if (!_controlPoints) {
        
        _controlPoints = [[NSMutableArray alloc] init];
    }
    
    return _controlPoints;
}

#pragma mark Lazy Shape Layer
- (CAShapeLayer *)shapeLayer {
    
    if (!_shapeLayer) {
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        _shapeLayer.lineWidth = 1.0f;
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

#pragma mark Lazy Begin Point
- (MLControlPointView *)beginPoint {
    
    if (!_beginPoint) {
        
        __weak __typeof(&*self)weakSelf = self;
        _beginPoint = [MLControlPointView controlPointViewWithPoint: CGPointMake(100, kHeight_ScreenHeight * 0.5)
                                                               type: MLControlPointViewTypeBeginPoint
                                                         movedBlock:^{
                                                             [weakSelf configureBezierPath];
                                                               }
                                         coordinateLabelClickAction:^(MLControlPointView * _Nonnull controlPointView) {
                                                            [weakSelf inputCoordinate: controlPointView];
                                                               }];
    }
    
    return _beginPoint;
}

#pragma mark Lazy End Point
- (MLControlPointView *)endPoint {
    
    if (!_endPoint) {
        
        __weak __typeof(&*self)weakSelf = self;
        _endPoint = [MLControlPointView controlPointViewWithPoint: CGPointMake(kWidth_ScreenWidth - 100, kHeight_ScreenHeight * 0.5)
                                                             type: MLControlPointViewTypeEndPoint
                                                       movedBlock:^{
                                                            [weakSelf configureBezierPath];
                                                        }
                                       coordinateLabelClickAction:^(MLControlPointView * _Nonnull controlPointView) {
                                                            [weakSelf inputCoordinate: controlPointView];
                                                        }];
    }
    
    return _endPoint;
}


#pragma mark - Init Methods
#pragma mark -
#pragma mark Configure UI
- (void) configureUI {
    
    // 0. Shape Layer
    [self.view.layer addSublayer: self.shapeLayer];
    
    // 1. BeginPoint  And  EndPoint
    [self.view addSubview: self.beginPoint];
    [self.view addSubview: self.endPoint];
    
    // 2. Add Button
    [self.view addSubview: self.addButton];
}


#pragma mark - Actions
#pragma mark -
#pragma mark Add Control Point Action
- (void) addControlPointAction:(UIButton *)sender {
    
    // 1. 判断数组长度是否大于2
    if (self.controlPoints.count >= 2) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Warning"
                                                                                 message: @"You can only add less than three control point"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle: @"OK, I Known"
                                                             style: UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                           }]];
        [self presentViewController: alertController
                           animated: YES
                         completion: nil];
        return;
    }
    
    // 2. 创建 MLControlPointView
    __weak __typeof(&*self)weakSelf = self;
    MLControlPointView *controlPointView = [MLControlPointView controlPointViewWithPoint: CGPointMake(kWidth_ScreenWidth * 0.5,  200)
                                                                                    type: MLControlPointViewTypeControlPoint
                                                                              movedBlock:^{
                                                                                [weakSelf configureBezierPath];
                                                                               }
                                                              coordinateLabelClickAction:^(MLControlPointView * _Nonnull controlPointView) {
                                                                                [weakSelf inputCoordinate: controlPointView];
                                                                               }];
    controlPointView.removeAction = ^(MLControlPointView *controlPointView){
        [weakSelf removeControlPoint: controlPointView];
    };
    [self.view addSubview: controlPointView];
    [self.controlPoints addObject: controlPointView];
    
    // 3. 刷新 UI
    [self configureBezierPath];
}


#pragma mark - Private Methods
#pragma mark -
#pragma mark Remove Control Point
- (void) removeControlPoint:(MLControlPointView *)controlPointView {
    
    // 1. 从数组中移除
    [self.controlPoints removeObject: controlPointView];
    
    // 2. 从父试图中移除
    [controlPointView removeFromSuperview];
    
    // 3. 刷新 UI
    [self configureBezierPath];
}

#pragma mark Configure Bezier Path
- (void) configureBezierPath {
    
    // 1. 删除所有点
    [self.bezierPath removeAllPoints];
    [self.dashedLineBezierPath_BeginPoint removeAllPoints];
    [self.dashedLineBezierPath_EndPoint removeAllPoints];
    
    // 2. 移动到起始点
    [self.bezierPath moveToPoint: self.beginPoint.controlPoint];
    
    // 3. 判断 控制点 个数
    if (self.controlPoints.count == 1) {
        
        [self.bezierPath addQuadCurveToPoint: self.endPoint.controlPoint
                                controlPoint: [self.controlPoints firstObject].controlPoint];
        
        // 3.1 添加虚线
        [self.dashedLineBezierPath_BeginPoint moveToPoint: self.beginPoint.controlPoint];
        [self.dashedLineBezierPath_BeginPoint addLineToPoint: [self.controlPoints firstObject].controlPoint];
        [self.dashedLineBezierPath_BeginPoint addLineToPoint: self.endPoint.controlPoint];
        self.dashedLineShapeLayer_BeginPoint.path = self.dashedLineBezierPath_BeginPoint.CGPath;
        
    } else if (self.controlPoints.count == 2) {
        
        [self.bezierPath addCurveToPoint: self.endPoint.controlPoint
                           controlPoint1: [self.controlPoints firstObject].controlPoint
                           controlPoint2: [self.controlPoints lastObject].controlPoint];
        
        // 3.1 添加虚线
        [self.dashedLineBezierPath_BeginPoint moveToPoint: self.beginPoint.controlPoint];
        [self.dashedLineBezierPath_BeginPoint addLineToPoint: [self.controlPoints firstObject].controlPoint];
        [self.dashedLineBezierPath_EndPoint moveToPoint: self.endPoint.controlPoint];
        [self.dashedLineBezierPath_EndPoint addLineToPoint: [self.controlPoints lastObject].controlPoint];
        self.dashedLineShapeLayer_BeginPoint.path = self.dashedLineBezierPath_BeginPoint.CGPath;
        self.dashedLineShapeLayer_EndPoint.path = self.dashedLineBezierPath_EndPoint.CGPath;
        
        
    } else if (!self.controlPoints.count) {
        
        [self.bezierPath addLineToPoint: self.endPoint.controlPoint];
    }
    
    // 4. 将路径赋值给 CAShapeLayer
    self.shapeLayer.path = self.bezierPath.CGPath;
}

#pragma mark Input Coordinate
- (void) inputCoordinate:(MLControlPointView *)controlPointView {
    
    __weak __typeof(&*self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil
                                                                   message: @"Please input coordinate in main screen"
                                                            preferredStyle: UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alert addAction: [UIAlertAction actionWithTitle: @"OK"
                                               style: UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 
                                                 NSArray<UITextField *> *textFields = alert.textFields;
                                                 NSString *textX = [textFields firstObject].text;
                                                 NSString *textY = [textFields firstObject].text;
                                                 CGFloat x = [textX floatValue];
                                                 CGFloat y = [textY floatValue];
                                                 
                                                 if (x > kWidth_ScreenWidth || x < 0 || !textX.length) return;
                                                 if (y > kHeight_ScreenHeight || y < 0 || !textY.length) return;
                                                 
                                                 controlPointView.center = CGPointMake(x, y);
                                                 controlPointView.controlPoint = controlPointView.center;
                                                 [weakSelf configureBezierPath];
                                                 [controlPointView showCoordinateLabelAndDelayHide];
                                                 
                                             }]];
    [alert addAction: [UIAlertAction actionWithTitle: @"Cancel"
                                               style: UIAlertActionStyleCancel
                                             handler:^(UIAlertAction * _Nonnull action) {
                                             }]];
    [self presentViewController: alert
                       animated: YES
                     completion: nil];
}

@end
