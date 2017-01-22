
//  UIView+views.m



#import "UIView+views.h"

@implementation UIView (views)

@dynamic maxX;
@dynamic maxY;
@dynamic viewController;
@dynamic navigationController;

- (void)packUpKeyboard
{
    [self endEditing:YES];
}

+ (UILabel *)copyLabel:(UILabel *)label {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:label];
    UILabel* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (UITextField *)copyTextField:(UITextField *)label {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:label];
    UITextField* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

+ (UIButton *)copyButton:(UIButton *)button {
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:button];
    UIButton* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

- (void)addHeadSeparator:(UIColor *)color{
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    separator.backgroundColor = color;
    [self addSubview:separator];
}

- (void)removeAllSubviews
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)maxX
{
    
    return CGRectGetMaxX(self.frame);
    
}

- (CGFloat)maxY
{
    
    return CGRectGetMaxY(self.frame);
    
}

- (UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)navigationController
{
    
    return self.viewController.navigationController;
    
}


@end
