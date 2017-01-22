# XXBezierTransform
iOS分类--类似电商等项目中商品图片加入购物车动画效果(将敬业福加入购物车)

下面给大家说一个将敬业福加入购物车的方法😁

在项目过程中所涉及到的一个需求,效果和天猫京东等的那种控制器下沉,然后具体商品型号类型等的展示view弹出,加入购物车时图片的动画效果差不多,经过一些研究查阅之后做了一个非常标准的实现,并且在此基础上做了稍稍一些扩展.大体效果如下:

![record01.gif](http://upload-images.jianshu.io/upload_images/1717878-7ab22def8f31c6cd.gif?imageMogr2/auto-orient/strip)


![record03.gif](http://upload-images.jianshu.io/upload_images/1717878-b7e83ec868365db3.gif?imageMogr2/auto-orient/strip)


![record04.gif](http://upload-images.jianshu.io/upload_images/1717878-8ff26082e41e5766.gif?imageMogr2/auto-orient/strip)

实现方式是通过 UIImageView + Category 的方式实现的,用分类的方式来实现不会对原有类产生任何影响.

动画过程是以``UIBezierPath, CABasicAnimation``及其子类``CAKeyframeAnimation``等来实现的,并且通过运行时 ``runtime`` 的特性为分类增加了一些属性,更加方便我们去调用设置.大体想法是通过贝塞尔路径画出图片所要做的位移路径,并且在图片做位移动画的过程中,通过CABasicAnimation核心动画的控制,让图片的旋转,缩放,抛物线,移动速率等的动画同时发生.

已经写过一篇文章讲述了[控制器的3D下沉上升效果](http://www.jianshu.com/p/ea8f16fdac17),这里就不多说了.主要分析下图片动画的过程.整个图片的位移路径首先是通过贝塞尔路径来控制的,先说一下简单的一个中心控制点的路径,大多数电商APP图片的移动路径也都是这种的:

```
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = [self convertPoint:self.center toView:nil];
    CGPoint endPoint = [[[self endPointAndHadianHeightByTransformEndType:transformType] firstObject] CGPointValue];
```
######简单方式: 为路径设置一个中心控制点(抛物线单顶点):######
```
    CGFloat radianHeight = [[[self endPointAndHadianHeightByTransformEndType:transformType] lastObject] floatValue];
    
    float sx = startPoint.x,    sy = startPoint.y,  ex = endPoint.x,    ey = endPoint.y;
    float x = sx + (ex - sx)/3,  y = sy + (ey - sy)*0.5 - radianHeight;
    CGPoint centerPoint=CGPointMake(x,y);

```
然后将起始点和中心点都加入贝塞尔路径中,同时调用自定义的``CAAnimation``核心动画方法:
```
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    [self transformWithBezierPath:path duration:duration];
```


######两个控制点的方式: 为路径设置两个控制点(一上一下两个顶点):######
```
    CGFloat radianHeight = [[[self endPointAndHadianHeightByTransformEndType:transformType] lastObject] floatValue];
    
    CGPoint controlPoint1 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:radianHeight] firstObject] CGPointValue];
    CGPoint controlPoint2 = [[[self controlPointsByParabolaType:parabolaType startPoint:startPoint endPoint:endPoint radianHeight:radianHeight] lastObject] CGPointValue];

    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
```


自定义的``CAAnimation``核心动画方法``- (void)transformWithBezierPath:(UIBezierPath *)path duration:(NSTimeInterval)duration;``内,

首先要确定一件事:该部分执行动画的图层全部都以  ``keyWindow``  为参考系进行的,并且要为图层新建一个layer对象作为执行动画的图层,让图片在新的layer上进行位移,不然会直接作用于原图片.  
然后在此基础上实现三个动画:图层的抛物线,图层的旋转和图层的尺寸缩放:
```
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

```
分类里具体提供了三个方法供大家来调用:
```
/**
 *  图片做贝塞尔路径的形变位移便捷方法
 *
 *  @param transformType 位移的结束点类型
 */
- (void)animationWithBezierPathTransformEndType:(TransformEndType)transformType duration:(NSTimeInterval)duration;

/**
 *  图片做多控制点贝塞尔路径的形变位移标准方法
 *
 *  @param parabolaType 贝塞尔抛物线类型
 *  @param view         目标view
 */
- (void)animationWithBezierPathTransformParabolaType:(ParabolaType)parabolaType toView:(UIView *)view duration:(NSTimeInterval)duration;

/**
 *  图片做多控制点贝塞尔路径的形变位移扩展方法
 *
 *  @param transformType 位移的结束点类型
 *  @param parabolaType  贝塞尔抛物线类型
 */
- (void)animationWithTwoControlPointsBezierPathTransformEndType:(TransformEndType)transformType parabolaType:(ParabolaType)parabolaType duration:(NSTimeInterval)duration;

```
便捷方法只需要传入动画时间``duration ``以及
```
/** 位移的结束点类型 */
typedef NS_ENUM(NSInteger, TransformEndType) {
    /** 结束点 : 导航条的右上角 */
    TypeNavRightItemPoint = 0,
    /** 结束点 : Tabbar的第3个(从0开始) */
    TypeTabBarIndex3Point = 1,
    /** 结束点 : 与选中图片对称 */
    TypeSymmetricWithImage = 2,
    /** 结束点 : 自定义结束点,需要设提前置endPoint与radianHeight */
    TypeCustomPoint = 3,
};
```
的枚举值,通常情况下直接选定比如``TypeNavRightItemPoint``就好;

标准方法需要传入我们的位移目标位置出的小视图,比如导航条的右侧按钮,``tabbar``的第几个按钮等,因为一旦选用控制器3D下沉效果的话,导航条的右侧按钮相对于``keyWindow``的位置是会改变的,如果继续选择第一个方法,最终的位置会出现偏差:

![record06.gif](http://upload-images.jianshu.io/upload_images/1717878-aaaffc2fa6575038.gif?imageMogr2/auto-orient/strip)


看到没,敬业福我们可以直接购买了😂

换上标准方法就好了,传入目标view,如下调用:

```
//        [self.goodImage animationWithBezierPathTransformEndType:TypeNavRightItemPoint duration:duration];
        
        UIView *view = self.currentVc.navigationItem.rightBarButtonItem.customView;
        [self.goodImage animationWithBezierPathTransformParabolaType:ParabolaTypeUp toView:view duration:duration];

``` 
可以看到不管控制器有没有下沉,导航条右按钮相对window的frame跑到哪里,都可以准确地定位到其中:

![record07.gif](http://upload-images.jianshu.io/upload_images/1717878-204abe574f61f716.gif?imageMogr2/auto-orient/strip)



扩展方法主要是多了一个```/** 贝塞尔抛物线类型 */
typedef NS_ENUM(NSInteger, ParabolaType) {
    /** 上顶点 */
    ParabolaTypeUp = 0,
    /** 先下后上 */
    ParabolaTypeDownAndUp = 1,
    /** 先上后下 */
    ParabolaTypeUpAndDown = 2,
};
```枚举值参数,用来修改抛物线的形状,就可以实现 一个/两个 控制点的方式.比如直接拿imageView这样调用:
```
 [self.goodImage animationWithTwoControlPointsBezierPathTransformEndType:TypeNavRightItemPoint parabolaType:ParabolaTypeDownAndUp duration:duration];
```
最终效果:

![record08.gif](http://upload-images.jianshu.io/upload_images/1717878-e81e79010f3ca5e6.gif?imageMogr2/auto-orient/strip)
