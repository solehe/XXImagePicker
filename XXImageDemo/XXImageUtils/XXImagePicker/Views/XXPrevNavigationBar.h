//
//  XXPrevNaviBar.h
//  XXImageDemo
//
//  Created by solehe on 2020/7/15.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXPrevNavigationBar;

NS_ASSUME_NONNULL_BEGIN

@protocol XXPrevNavigationBarDelegate <NSObject>

@optional

// 点击了返回按钮
- (void)prevNavigationBarDidClickedBack:(XXPrevNavigationBar *)naviBar;

@end

@interface XXPrevNavigationBar : UIView

// 代理
@property (nonatomic, weak) id<XXPrevNavigationBarDelegate> delegate;
// 返回按钮
@property (nonatomic, strong) UIButton *backButton;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 选择按钮
@property (nonatomic, strong) UIButton *selectButton;
// 右上角选中计数
@property (nonatomic, strong) UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
