//
//  XXImagePrevViewController.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXImagePrevViewControllerDelegate;
@class XXImagePickerConfigure;
@class XXPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface XXImagePrevViewController : UIViewController

// 当前已选择的模型
@property (nonatomic, weak) NSMutableArray<XXPhotoModel *> *selectedPhotos;
// 相片模型列表
@property (nonatomic, strong) NSArray<XXPhotoModel *> *photos;
// 当前点击的模型
@property (nonatomic, weak) XXPhotoModel *currentPhoto;

#pragma mark - 防止外部初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure;
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure
                         delegate:(id<XXImagePrevViewControllerDelegate> __nullable)delegate;

@end


#pragma mark - XXImagePrevViewControllerDelegate

@protocol XXImagePrevViewControllerDelegate <NSObject>



@end

NS_ASSUME_NONNULL_END
