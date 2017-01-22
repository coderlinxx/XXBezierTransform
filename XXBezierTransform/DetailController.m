//
//  DetailController.m
//  XXBezierTransform
//
//  Created by inxx on 17/1/18.
//  Copyright © 2017年 GoGoGold E-Commerce Co.Ltd. All rights reserved.
//

#import "DetailController.h"
#import "GoodSelectView.h"
#import "MacroHeader.h"

@interface DetailController ()
@property(strong,nonatomic)UIBarButtonItem *rightItem;
@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (IBAction)normalShow:(UIButton *)sender {
    GoodSelectView *goodSelectView = [[GoodSelectView alloc]initWithFrame:self.view.bounds];
    goodSelectView.currentVc = self;
    [goodSelectView show];
}

- (IBAction)fallWithNav:(UIButton *)sender {
    GoodSelectView *goodSelectView = [[GoodSelectView alloc]initWithFrame:self.view.bounds];
    goodSelectView.currentVc = self;
    [goodSelectView showWith3D:YES];
}

- (IBAction)riseWithNav:(UIButton *)sender {
    [self closeWithDuration:0.5 transformType:TransformTypeM32];
}


#pragma mark - 懒加载

-(UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *btn = [[UIButton alloc] init];
        [btn sizeToFit];
        [btn setImage:[UIImage imageNamed:@"shoppingcart"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _rightItem;
}

-(void)gotoShoppingCart:(UIButton *)btn{
    NSLog(@"前往购物车");
}

@end
