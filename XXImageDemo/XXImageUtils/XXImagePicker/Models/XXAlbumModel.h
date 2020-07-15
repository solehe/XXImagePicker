//
//  XXAlbumModel.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHFetchResult;
@class XXPhotoModel;

@interface XXAlbumModel : NSObject

// 名称
@property (nonatomic, copy) NSString *name;
// 是否是相机拍摄
@property (nonatomic, assign) BOOL isCameraRoll;
// 图片集合
@property (nonatomic, strong) PHFetchResult *result;
// 个数
@property (nonatomic, assign, readonly) NSUInteger count;

// 相片集合
@property (nonatomic, copy) NSArray<XXPhotoModel *> *photos;

@end

NS_ASSUME_NONNULL_END
