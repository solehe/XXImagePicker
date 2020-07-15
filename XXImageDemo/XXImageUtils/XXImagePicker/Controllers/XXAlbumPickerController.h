//
//  XXAlbumPickerController.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXAlbumPickerController;
@class XXImagePickerConfigure;
@class XXAlbumModel;

@protocol XXAlbumPickerControllerDelegate <NSObject>

@optional
- (void)albumPickerController:(XXAlbumPickerController *)pickerVc didSelectedAlbum:(XXAlbumModel *)album;

@end


@interface XXAlbumPickerController : UIViewController

// 代理
@property (nonatomic, weak) id<XXAlbumPickerControllerDelegate> delegate;

#pragma mark - 防止外部初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure
                         delegate:(id<XXAlbumPickerControllerDelegate>)delegate;

// 展示、隐藏
- (void)show:(void(^)(void))compelete;
- (void)hidden:(void(^)(void))compelete;

@end

NS_ASSUME_NONNULL_END
