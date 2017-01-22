//
//  UIViewController+XXProgressTool.h
//  工厂店赚钱宝
//
//  Created by inxx on 16/6/24.
//  Copyright © 2016年 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKLoadingView.h"



@interface UIViewController (XXProgressTool)

/** 自定义加载进程 View */
@property(nonatomic, strong)MKLoadingView *loadingView;

- (void)emptyView;
- (void)emptyViewWithString:(NSString *)text;
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)failAndReLoadingView;
-(void)failAndReLoadingFirstData;
- (void)reLoadingViewEnabled:(BOOL)isYes;

@end
