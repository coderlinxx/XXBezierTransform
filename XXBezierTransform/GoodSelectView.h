//
//  GoodSelectView.h
//  XXBezierTransform
//
//  Created by inxx on 17/1/20.
//  Copyright © 2017年 GoGoGold E-Commerce Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodSelectView : UIView

/**
 *  显示
 */
- (void)show;

/**
 *  消失
 */
- (void)dismiss;


/**
 *  3D显示
 */
- (void)showWith3D:(BOOL)isYes;

/**
 *  3D消失
 */
- (void)dismissWith3D:(BOOL)isYes;

@end
