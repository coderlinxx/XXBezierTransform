//
//  UIViewController+XXPushAnimation.h
//  XXPushAnimation
//
//  Created by inxx on 16/8/29.
//  Copyright © 2016年 GoGoGold E-Commerce Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 动画类型 */
typedef NS_ENUM(NSInteger, AnimationType) {
    /** 淡入淡出 */
    AnimationTypeFade = 1,                   //淡入淡出
    /** 推挤 */
    AnimationTypePush,                       //推挤
    /**揭开 */
    AnimationTypeReveal,                     //揭开
    /** 覆盖 */
    AnimationTypeMoveIn,                     //覆盖
    /**立方体 */
    AnimationTypeCube,                       //立方体
    /** 吮吸 */
    AnimationTypeSuckEffect,                 //吮吸
    /** 翻转 */
    AnimationTypeOglFlip,                    //翻转
    /** 波纹 */
    AnimationTypeRippleEffect,               //波纹
    /** 翻页 */
    AnimationTypePageCurl,                   //翻页
    /** 反翻页 */
    AnimationTypePageUnCurl,                 //反翻页
    /** 开镜头 */
    AnimationTypeCameraIrisHollowOpen,       //开镜头
    /** 关镜头 */
    AnimationTypeCameraIrisHollowClose,      //关镜头
    /** 下翻页 */
    AnimationTypeCurlDown,                   //下翻页
    /** 上翻页 */
    AnimationTypeCurlUp,                     //上翻页
    /** 左翻转 */
    AnimationTypeFlipFromLeft,               //左翻转
    /** 右翻转 */
    AnimationTypeFlipFromRight,              //右翻转
};

@interface UIViewController (XXPushAnimation)


/**
 *  控制器间跳转时的动画效果
 *
 *  @param type    动画类型枚举值
 *  @param subtype 动画子类型(动画的更详细效果)
 */
- (void) transitionWithEnumType:(AnimationType) animationType WithSubtype:(NSString *) subtype;


/**
 *  视图间跳转时的动画效果
 *
 *  @param type    动画类型
 *  @param subtype 动画子类型(动画的更详细效果)
 *  @param view    视图
 */
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view;

@end
