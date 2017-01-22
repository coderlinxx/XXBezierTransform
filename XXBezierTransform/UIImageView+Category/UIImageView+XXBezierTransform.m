//
//  UIImageView+XXBezierTransform.m
//  XXBezierTransform
//
//  Created by inxx on 16/6/12.
//  Copyright © 2016年 林祥星linxx. All rights reserved.
//

#import "UIImageView+XXBezierTransform.h"
#import <objc/runtime.h>

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define DefaultRadianH 150 //默认弧度高度
#define DefaultDuration 0.75

@implementation UIImageView (XXBezierTransform)


- (void)animationWithBezierPathTransformEndType:(TransformEndType)transformType  duration:(NSTimeInterval)duration{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = [self convertPoint:self.center toView:nil];
    CGPoint endPoint = [[[self endPointAndHadianHeightByTransformEndType:transformType] firstObject] CGPointValue];
    CGFloat radianHeight = [[[self endPointAndHadianHeightByTransformEndType:transformType] lastObject] floatValue];
    
    float sx = startPoint.x,    sy = startPoint.y,  ex = endPoint.x,    ey = endPoint.y;
    float x = sx + (ex - sx)/3,  y = sy + (ey - sy)*0.5 - radianHeight;
    CGPoint centerPoint=CGPointMake(x,y);
    
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    [self transformWithBezierPath:path duration:duration];
}

- (void)animationWithTwoControlPointsBezierPathTransformEndType:(TransformEndType)transformType parabolaType:(ParabolaType)parabolaType duration:(NSTimeInterval)duration{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = [self convertPoint:self.center toView:nil];
    CGPoint endPoint = [[[self endPointAndHadianHeightByTransformEndType:transformType] firstObject] CGPointValue];
    CGFloat radianHeight = [[[self endPointAndHadianHeightByTransformEndType:transformType] lastObject] floatValue];
    
    CGPoint controlPoint1 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:radianHeight] firstObject] CGPointValue];
    CGPoint controlPoint2 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:radianHeight] lastObject] CGPointValue];

    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    [self transformWithBezierPath:path duration:duration];
}


- (void)animationWithBezierPathTransformParabolaType:(ParabolaType)parabolaType toView:(UIView *)view duration:(NSTimeInterval)duration{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGPoint startPoint = [self convertPoint:self.center toView:window];
    CGPoint endPoint = [view convertRect: view.bounds toView:window].origin;

    CGPoint controlPoint1 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:DefaultRadianH] firstObject] CGPointValue];
    CGPoint controlPoint2 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:DefaultRadianH] lastObject] CGPointValue];

    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    [self transformWithBezierPath:path duration:duration];
}

- (NSArray *)endPointAndHadianHeightByTransformEndType:(TransformEndType)transformType{
    
    CGPoint startPoint = [self convertPoint:self.center toView:nil];
    CGPoint endPoint = CGPointZero;
    CGFloat radianHeight = 0.0;   // 抛物线弧度高度
    
    switch (transformType) {
        case TypeNavRightItemPoint:
            endPoint = CGPointMake(WIDTH - 30,  30);
            radianHeight = DefaultRadianH;
            break;
        case TypeTabBarIndex3Point:
            endPoint = CGPointMake(WIDTH*0.7, HEIGHT - 30);
            radianHeight = DefaultRadianH*2;
            break;
        case TypeSymmetricWithImage:
            endPoint = CGPointMake(WIDTH - 30, startPoint.y);
            radianHeight = startPoint.y * 0.66;
            break;
        case TypeCustomPoint:
            endPoint = self.endPoint;
            radianHeight = self.radianHeight;
            break;
        default:
            endPoint = CGPointMake(WIDTH - 30,  30);
            radianHeight = DefaultRadianH;
            break;
    }
    
    NSValue *value1 = [NSValue valueWithCGPoint:endPoint];
    NSNumber *value2 = [NSNumber numberWithFloat:radianHeight];
    return @[value1,value2];
}

- (NSArray *)controlPointsByParabolaType:(ParabolaType)parabolaType startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  radianHeight:(CGFloat)radianHeight {
    
    float sx = startPoint.x,    sy = startPoint.y,  ex = endPoint.x,    ey = endPoint.y;
    float x = 0,  y = 0, x2 = 0,  y2 = 0;
    switch (parabolaType) {
        case ParabolaTypeUp:
            x = sx + (ex - sx)/3,  y = sy + (ey - sy)*0.5 - radianHeight;
            x2 = x,  y2 = y;
            break;
        case ParabolaTypeUpAndDown:
            x = sx + (ex - sx)*0.2,  y = sy + (ey - sy)*0.5 - radianHeight;
            x2 = sx + (ex - sx)*0.5,  y2 = sy - (ey - sy)*0.5 + radianHeight;
            break;
        case ParabolaTypeDownAndUp:
            x = sx + (ex - sx)*0.2,  y = sy - (ey - sy)*0.5 + radianHeight;
            x2 = sx + (ex - sx)*0.5,  y2 = sy + (ey - sy)*0.5 - radianHeight;
            break;
        default:
            break;
    }
    
    NSValue *Point1 = [NSValue valueWithCGPoint:CGPointMake(x,y)];
    NSValue *Point2 = [NSValue valueWithCGPoint:CGPointMake(x2,y2)];
    return @[Point1,Point2];
}


//主要方法
- (void)transformWithBezierPath:(UIBezierPath *)path duration:(NSTimeInterval)duration{
    
    //该部分动画的imageview 全部都以  keyWindow  为参考系进行
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CGRect rect = [self convertRect:self.bounds toView:window];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = self.layer.contents;
    layer.frame = rect;
    layer.opacity = 1;
    [window.layer addSublayer:layer];

    //抛物线
    CAKeyframeAnimation *parabolaPathAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    parabolaPathAnimation.path = path.CGPath;   //pao
    parabolaPathAnimation.autoreverses = NO;  //自动复位为NO
    parabolaPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    parabolaPathAnimation.duration = duration;
    parabolaPathAnimation.fillMode = kCAFillModeForwards; //动画状态是否保持
    parabolaPathAnimation.removedOnCompletion = NO;    //完成后移除
    
    //旋转
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 8];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    rotationAnimation.cumulative = YES;
    rotationAnimation.duration = duration;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    
    
    //尺寸缩放
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1),
    scale2 = CATransform3DMakeScale(0.65, 0.65, 1),
    scale3 = CATransform3DMakeScale(0.2, 0.2, 1),
    scale4 = CATransform3DMakeScale(.0, .0, 1);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4], nil];
    [transformAnimation setValues:frameValues];
    //两种速率控制方式均可
    NSArray *frameTimes = [NSArray arrayWithObjects:@0,@0.5,@0.8,@1,nil];
    [transformAnimation setKeyTimes:frameTimes];
    //    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transformAnimation.duration = duration;
    transformAnimation.fillMode = kCAFillModeForwards;
    transformAnimation.removedOnCompletion = NO;
    
    
    [layer addAnimation:parabolaPathAnimation forKey:@"parabolaPathAnimation"];
    [layer addAnimation:transformAnimation forKey:@"transformAnimation"];
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - runtime

@dynamic endPoint;
@dynamic radianHeight;

static const char *EndPointKey = "EndPointKey";
static const char *RadianHeightKey = "RadianHeightKey";

-(void)setEndPoint:(CGPoint)endPoint{
    NSValue *pointValue = [NSValue valueWithCGPoint:endPoint];
    objc_setAssociatedObject(self, &EndPointKey, pointValue, OBJC_ASSOCIATION_ASSIGN);
}
-(CGPoint)endPoint{
    CGPoint point = [objc_getAssociatedObject(self, &EndPointKey) CGPointValue];
    return (point.x != 0 && point.y != 0) ? point :  CGPointMake(WIDTH - 30,  HEIGHT/2);
}

-(void)setRadianHeight:(CGFloat)radianHeight{
    NSNumber *number = [NSNumber numberWithFloat:radianHeight];
    objc_setAssociatedObject(self, &RadianHeightKey, number, OBJC_ASSOCIATION_ASSIGN);
}
-(CGFloat)radianHeight{
    CGFloat height = [objc_getAssociatedObject(self, &RadianHeightKey) floatValue];
    return height != 0 ? height : 300;
}


@end
