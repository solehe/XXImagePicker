//
//  XXPhotoPickerViewController.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXImagePickerConfigure;

NS_ASSUME_NONNULL_BEGIN

@interface XXPhotoPickerController : UIViewController

#pragma mark - 防止外部初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure;

@end

NS_ASSUME_NONNULL_END
