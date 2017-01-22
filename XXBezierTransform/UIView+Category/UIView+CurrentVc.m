//
//  UIView+CurrentVc.m
//  XXBezierTransform
//
//  Created by inxx on 16/7/26.
//  Copyright © 2016年 林祥星linxx. All rights reserved.
//

#import "UIView+CurrentVc.h"
#import <objc/runtime.h>

@implementation UIView (CurrentVc)


@dynamic currentVc;

#pragma mark - runtime

static const char *CurrentVcKey = "CurrentVcKey";

-(void)setCurrentVc:(UIViewController *)currentVc{
    objc_setAssociatedObject(self, &CurrentVcKey, currentVc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController *)currentVc{
    return objc_getAssociatedObject(self, &CurrentVcKey);
}

@end
