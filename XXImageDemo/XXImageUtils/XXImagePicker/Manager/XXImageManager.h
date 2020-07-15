//
//  XXImageManager.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XXImagePickerConfigure;
@class XXAlbumModel;
@class XXPhotoModel;

NS_ASSUME_NONNULL_BEGIN

/**
 图片管理类
 */
@interface XXImageManager : NSObject

#pragma mark - 防止外部初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

#pragma mark - 外部调用方法

// 释放
+ (void)deallocManager;

// 获取相册列表
+ (void)fetchAlbums:(XXImagePickerConfigure *)configure result:(void(^)(NSArray<XXAlbumModel *> *albums))block;

// 获取相片列表
+ (void)fetchPhotos:(XXImagePickerConfigure *)configure album:(XXAlbumModel *)album result:(void(^)(NSArray<XXPhotoModel *> *photos))block;

// 获取缩略图
+ (void)fetchThumbnailImage:(XXPhotoModel *)model targetSize:(CGSize)targetSize result:(void(^)(UIImage *image, BOOL isCloud))block;

// 获取原图
+ (void)fetchOriginalImage:(XXPhotoModel *)model progress:(void(^)(CGFloat progress))progressBlock result:(void(^)(UIImage *image))block;


@end

NS_ASSUME_NONNULL_END
