//
//  XXPhotoModel.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XXPhotoType) {
    XXPhotoTypeUnkown,  //未知类型
    XXPhotoTypeImage,   //普通图片
    XXPhotoTypeLive,    //高清原图
    XXPhotoTypeGif,     //GIF
    XXPhotoTypeVideo,   //视频
    XXPhotoTypeVoice    //音频
};

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

/**
 相片模型
 */
@interface XXPhotoModel : NSObject

// 是否被选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
// 相片类型
@property (nonatomic, assign, readonly) XXPhotoType type;
// 时长（视频才有）
@property (nonatomic, assign) NSTimeInterval duration;
// 相片信息
@property (nonatomic, strong) PHAsset *asset;

// 是否下载过缩略图
@property (nonatomic, assign) BOOL isExistThumbnail;
// 本地是否存在原图
@property (nonatomic, assign) BOOL isExistOriginal;

// 是否正在下载
@property (nonatomic, assign) BOOL isDownloading;
// 下载监听
@property (nonatomic, copy) void(^downloadBlock)(BOOL finished, CGFloat progress, UIImage * __nullable image);

@end

NS_ASSUME_NONNULL_END
