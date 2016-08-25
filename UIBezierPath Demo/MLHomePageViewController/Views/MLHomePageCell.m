//
//  MLHomePageCell.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomePageCell.h"
#import "MLViewControllerJumpModel.h"

@interface MLHomePageCell ()

/**
 *  标题 Label
 */
@property (nonatomic, strong) UILabel *ml_titleLabel;

@end

@implementation MLHomePageCell
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark <#Method Name#>


#pragma mark - Override Methods
#pragma mark -
#pragma mark Setup UI
- (void) setupUI {
    
    // 1. Self
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 2. Setup Cell Background View
    [self setupCellBackgroundView];
}

#pragma mark Prepare Reuse
- (void) prepareForReuse {
    
    // 1. Setup Cell Background View
    [self setupCellBackgroundView];
}

#pragma mark Shake Complection
- (void) shakingComplection {
    if (self.didClick) {
        self.didClick(self, self.jumpModel);
    }
}

#pragma mark Cell Height
+ (CGFloat)cellHeight {
    return 64;
}


#pragma mark - Override Set / Get Methods
#pragma mark -
#pragma mark Set Jump Model
- (void) setJumpModel:(MLViewControllerJumpModel *)jumpModel {
    
    if (jumpModel == _jumpModel) return;
    _jumpModel = jumpModel;
    
    // Set Title
    self.ml_titleLabel.text = jumpModel.title;
}


#pragma mark - Lazy Load
#pragma mark -
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
#pragma mark <#Method Name#>


#pragma mark - Private Methods
#pragma mark -
#pragma mark Setup Cell Background View
- (void) setupCellBackgroundView {
    
    // 1. Configu View Cell Background
    self.viewCellBackground.frame = CGRectMake(_marginLeft, _marginTop, [UIScreen mainScreen].bounds.size.width - _marginLeft - _marginRight, [[self class] cellHeight]);
    
    // 2. UIBezier Path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: self.viewCellBackground.bounds
                                               byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomLeft
                                                     cornerRadii: CGSizeMake(10, 10)];
    
    // 3. CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    
    // 4. ViewCellBackground's mask
    self.viewCellBackground.layer.mask = shapeLayer;
}


#pragma mark - Action Methods
#pragma mark -
#pragma mark <#Method Name#>


@end
