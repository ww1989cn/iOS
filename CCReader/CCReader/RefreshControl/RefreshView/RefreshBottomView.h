//
//  RefreshBottomView.h
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

/**
 *	bottom view
 */
@interface RefreshBottomView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)UILabel *loadingLabel;//正在加载...
@property (nonatomic,strong)UILabel *promptLabel;//上拉加载更多

- (void)resetLayoutSubViews;
///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
