//
//  UIViewController+XXProgressTool.m
//  工厂店赚钱宝
//
//  Created by inxx on 16/6/24.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "UIViewController+XXProgressTool.h"
#import <objc/runtime.h>

@implementation UIViewController (XXProgressTool)

@dynamic loadingView;

- (void)showLoadingView{
    if (!self.loadingView) {
        MKLoadingView *loadingView = [[MKLoadingView alloc] init];
        loadingView.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1];
        loadingView.userInteractionEnabled = NO;
        
        self.loadingView = loadingView;
    }
    [self.loadingView showLoadingViewWithText:@"正在载入中..." animated:YES];
}

- (void)hideLoadingView{
    [self.loadingView hideLoadingView];
}


-(void)failAndReLoadingView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadData)];
    [self.loadingView addGestureRecognizer:tap];
    self.loadingView.userInteractionEnabled = YES;
    [self.loadingView showReloadViewWithText:@"加载失败，点击屏幕重试"];
}

-(void)failAndReLoadingFirstData{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadFirstData)];
    [self.loadingView addGestureRecognizer:tap];
    self.loadingView.userInteractionEnabled = YES;
    [self.loadingView showReloadViewWithText:@"加载失败，点击屏幕重试"];
}

- (void)reLoadingViewEnabled:(BOOL)isYes{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadData)];
    [self.loadingView addGestureRecognizer:tap];
    self.loadingView.userInteractionEnabled = YES;
    [self.loadingView showReloadViewWithText:@"加载失败，点击屏幕重试"];
}
-(void)loadData{
    NSLog(@"loadData实现于具体控制器!");
}
-(void)loadFirstData{
    NSLog(@"loadFirstData实现于具体控制器!");
}

- (void)emptyView{
    [self.loadingView showReloadViewWithText:@"暂无数据"];
}

- (void)emptyViewWithString:(NSString *)text{
    [self.loadingView showReloadViewWithText:text];
}


#pragma mark - runtime

static const char *LoadingViewKey = "LoadingViewKey";

-(void)setLoadingView:(MKLoadingView *)loadingView{
    if (loadingView != self.loadingView) {
        // 删除旧的，添加新的
        [self.loadingView removeFromSuperview];
        [self.view addSubview:loadingView];
        objc_setAssociatedObject(self, &LoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN);
    }
}

-(MKLoadingView *)loadingView{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}


@end
