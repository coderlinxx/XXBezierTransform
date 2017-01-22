//
//  UIViewController+XX3DFallAndRise.m
//  XX3DRiseAndFall
//
//  Created by inxx on 17/1/12.
//  Copyright © 2017年 GoGoGold E-Commerce Co.Ltd. All rights reserved.
//

#import "UIViewController+XX3DFallAndRise.h"

@implementation UIViewController (XX3DFallAndRise)

- (void)show{
    [self fallVcWithDuration:0.5f transformType:TransformTypeM34];
}
- (void)showWithDuration:(NSTimeInterval)duration{
    [self fallVcWithDuration:duration transformType:TransformTypeM34];
}
- (void)close{
    [self riseVcWithDuration:0.5f transformType:TransformTypeM34];
}
- (void)closeWithDuration:(NSTimeInterval)duration{
    [self riseVcWithDuration:duration transformType:TransformTypeM34];
}
- (void)showWithDuration:(NSTimeInterval)duration transformType:(TransformType)type{
    [self fallVcWithDuration:duration transformType:type];
}
- (void)closeWithDuration:(NSTimeInterval)duration transformType:(TransformType)type{
    [self riseVcWithDuration:0.5f transformType:type];
}


- (void) riseVcWithDuration:(NSTimeInterval)duration transformType:(TransformType)type{
    
    UIViewController *controller = [self getActionController];
    
    [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [controller.view.layer setTransform:[self firstTransformType: type]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [controller.view.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

- (void) fallVcWithDuration:(NSTimeInterval)duration transformType:(TransformType)type{
    
    UIViewController *controller = [self getActionController];
    
    [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [controller.view.layer setTransform:[self firstTransformType:type]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [controller.view.layer setTransform:[self secondTransformType:type]];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}


- (CATransform3D)firstTransformType:(TransformType)type{
    
    CATransform3D t1 = CATransform3DIdentity;
    CGFloat m = 1.0/-900;
    switch (type) {
        case TransformTypeM32:
            t1.m32 = m;
            break;
        default:
            t1.m34 = m;
            break;
    }
    //t1.m32 = 1.0/-900;
    
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransformType:(TransformType)type{
    
    CATransform3D t2 = CATransform3DIdentity;
    switch (type) {
        case TransformTypeM32:
            t2.m32 = [self firstTransformType:type].m32;
            break;
        default:
            t2.m34 = [self firstTransformType:type].m34;
            break;
    }
    //t2.m32 = [self firstTransformType:type].m32;
    
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}

-(UIViewController *)getActionController{
    return self.navigationController ? self.navigationController : self;
}

@end
