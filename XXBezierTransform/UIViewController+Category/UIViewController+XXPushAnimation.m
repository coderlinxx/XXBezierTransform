//
//  UIViewController+XXPushAnimation.h
//  XXPushAnimation
//
//  Created by inxx on 16/8/29.
//  Copyright © 2016年 GoGoGold E-Commerce Co.Ltd. All rights reserved.
//

#import "UIViewController+XXPushAnimation.h"

@implementation UIViewController (XXPushAnimation)

- (void) transitionWithEnumType:(AnimationType) animationType WithSubtype:(NSString *) subtype{
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.35f;
    
    //设置运动type
    switch (animationType) {
        case AnimationTypeFade:
            animation.type = kCATransitionFade;
            break;
            
        case AnimationTypePush:
            animation.type = kCATransitionPush;
            break;
            
        case AnimationTypeReveal:
            animation.type = kCATransitionReveal;
            break;
            
        case AnimationTypeMoveIn:
            animation.type = kCATransitionMoveIn;
            break;
            
        case AnimationTypeCube:
            animation.type = @"cube";
            break;
            
        case AnimationTypeSuckEffect:
            animation.type = @"suckEffect";
            break;
            
        case AnimationTypeOglFlip:
            animation.type = @"oglFlip";
            break;
            
        case AnimationTypeRippleEffect:
            animation.type = @"rippleEffect";
            break;
            
        case AnimationTypePageCurl:
            animation.type = @"pageCurl";
            break;
            
        case AnimationTypePageUnCurl:
            animation.type = @"pageUnCurl";
            break;
            
        case AnimationTypeCameraIrisHollowOpen:
            animation.type = @"cameraIrisHollowOpen";
            break;
            
        case AnimationTypeCameraIrisHollowClose:
            animation.type = @"cameraIrisHollowClose";
            break;
            
        case AnimationTypeCurlDown:
        case AnimationTypeCurlUp:
            animation.type = @"pageCurl";
            animation.subtype = subtype;
            break;
            
        case AnimationTypeFlipFromLeft:
        case AnimationTypeFlipFromRight:
            animation.type = @"oglFlip";
            animation.subtype = subtype;
            break;
            
        default:
            break;
    }
    
    
    //设置子类
    if (subtype != nil) {
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animation"];
}

#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.35f;
    
    //设置运动type
    animation.type = type;
    
    //设置子类
    if (subtype != nil) {
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}


@end
