//
//  XXPickerTabBar.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/30.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXPickerTabBar;

@protocol XXPickerTabBarDelegate <NSObject>

@optional

// 点击了预览
- (void)pickerTabBarDidClickPreview:(XXPickerTabBar *)bar;
// 点击了原图
- (void)pickerTabBar:(XXPickerTabBar *)bar didSelectedOrigin:(BOOL)origin;
// 点击了发送
- (void)pickerTabBarDidClickSend:(XXPickerTabBar *)bar;

@end

@interface XXPickerTabBar : UIView

// 代理
@property (nonatomic, weak) id<XXPickerTabBarDelegate> delegate;

// 相片选中个数变了
- (void)setSelectedPhotoCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
