//
//  MLHomePageCell.h
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell.h"

@class MLViewControllerJumpModel, MLHomePageCell;

/**
 *  The block of cell click
 */
typedef void(^MLHomePageCellDidClick)(MLHomePageCell *cell, MLViewControllerJumpModel *model);


@interface MLHomePageCell : MLBaseCell

/**
 *  View Controller Jump Model
 */
@property (nonatomic, weak) MLViewControllerJumpModel *jumpModel;

/** The block of cell click */
@property (nonatomic, copy) MLHomePageCellDidClick didClick;


/**
 *  Begin Animation
 */
- (void) beginAnimationWithAnimation;

/**
 *  Stop Animation
 */
- (void) stopAnimationWithAnimation;

@end
