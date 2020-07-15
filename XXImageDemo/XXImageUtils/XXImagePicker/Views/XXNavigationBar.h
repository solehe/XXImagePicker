//
//  XXPhotoPickerNavigationBar.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/29.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXNavigationBar;

@protocol XXNavigationBarDelegate <NSObject>

@optional
// 点击了取消
- (void)navigationBarDidCancel:(XXNavigationBar *)bar;
// 点击了切换按钮
- (void)navigationBar:(XXNavigationBar *)bar didSelected:(BOOL)selected;

@end

@interface XXNavigationBar : UIView

// 代理
@property (nonatomic, weak) id<XXNavigationBarDelegate> delegate;
// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
// 顶部相册切换按钮
@property (nonatomic, strong) UIButton *menuButton;

// 切换标题
- (void)setTitle:(NSString *)title;

// 改变选中状态
- (void)setSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
