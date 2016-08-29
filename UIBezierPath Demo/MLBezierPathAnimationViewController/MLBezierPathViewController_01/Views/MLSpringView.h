//
//  MLSpringView.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/29.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  MLSpringView Location Type
 *  Such As: Type Bottom means MLSpringView will show from the bottom of screen
 */
typedef NS_ENUM(NSInteger, MLSpringViewLocationType) {
    
    MLSpringViewLocationTypeBottom = 0,
    
    MLSpringViewLocationTypeTop = 1,
    
    MLSpringViewLocationTypeLeft = 2,
    
    MLSpringViewLocationTypeRight = 3,
    
    MLSpringViewLocationTypeNormal = MLSpringViewLocationTypeBottom
};

/**
 *  MLSpringView Display Type
 */
typedef NS_ENUM(NSInteger, MLSpringViewDisplayType) {
    
    MLSpringViewDisplayTypeNormal = 0,
    
    MLSpringViewDisplayTypeSkeleton = 1
};

@interface MLSpringView : UIView

/**
 *  Factory Method
 *
 *  @param frame           Frame
 *
 *  @return Instance of MLSpringView
 */
+ (instancetype) springViewWithContentViewFrame:(CGRect)frame;

/** Display Type */
@property (nonatomic, assign) MLSpringViewDisplayType displayType;

/** Content View */
@property (nonatomic, strong) UIView *contentView;

/**
 *  Show Spring View;
 */
- (void) show;

@end
