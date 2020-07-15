//
//  XXImageManager.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <CoreServices/CoreServices.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

#import "XXImagePickerConfigure.h"
#import "XXImageManager.h"
#import "XXAlbumModel.h"
#import "XXPhotoModel.h"

@interface XXImageManager ()

@end

@implementation XXImageManager

static XXImageManager *_shared;
static dispatch_once_t onceToken;

// 单利实现方法
+ (instancetype)shared {
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _shared = [[self alloc] init];
    });
    return _shared;
}

// 释放
+ (void)deallocManager {
    onceToken = 0;
    _shared = nil;
}

#pragma mark - 获取相册列表

// 获取相册列表
+ (void)fetchAlbums:(XXImagePickerConfigure *)configure result:(void(^)(NSArray<XXAlbumModel *> *albums))block {
    
    // 设置查询参数
    PHFetchOptions *options = [self optionsWithAlbumConfigure:configure];
    
    // 获取相册列表
    NSArray<PHFetchResult *> *albums = [self fetchAllAssetCollections];
    
    // 需要展示的相册列表
    [self displayAlbumArray:albums options:options result:^(NSArray<XXAlbumModel *> *albums) {
        for (XXAlbumModel *album in albums) { // 获取相片
            [self fetchPhotos:configure album:album result:^(NSArray<XXPhotoModel *> * _Nonnull photos) {
                [album setPhotos:photos];
            }];
        }
        // 返回结果
        if (block) { block(albums); }
    }];
}

+ (PHFetchOptions *)optionsWithAlbumConfigure:(XXImagePickerConfigure *)configure {
    
    // 设置查询参数
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    // 不允许查找视频
    if (!configure.isAllowVideo) {
        [options setPredicate:[NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage]];
    }
    
    // 不允许查找图片
    if (!configure.isAllowImage) {
        [options setPredicate:[NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo]];
    }
    
    // 降序排列（根据创建日期）
    if (!configure.ascending) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:configure.ascending];
        [options setSortDescriptors:@[descriptor]];
    }
    
    return options;
}

+ (NSArray<PHFetchResult *> *)fetchAllAssetCollections {
    
    // 用户的 iCloud 照片流
    PHAssetCollectionType type1 = PHAssetCollectionTypeAlbum;
    PHAssetCollectionSubtype subtype1 = PHAssetCollectionSubtypeAlbumMyPhotoStream;
    PHFetchResult *album1 = [PHAssetCollection fetchAssetCollectionsWithType:type1 subtype:subtype1 options:nil];
    
    // 用户在 Photos 中创建的相册
    PHAssetCollectionType type2 = PHAssetCollectionTypeSmartAlbum;
    PHAssetCollectionSubtype subtype2 = PHAssetCollectionSubtypeAlbumRegular;
    PHFetchResult *album2 = [PHAssetCollection fetchAssetCollectionsWithType:type2 subtype:subtype2 options:nil];
    
    // 用户个人相册
    PHFetchResult *album3 = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 从iPhoto同步到设备的相册
    PHAssetCollectionType type4 = PHAssetCollectionTypeAlbum;
    PHAssetCollectionSubtype subtype4 = PHAssetCollectionSubtypeAlbumSyncedAlbum;
    PHFetchResult *album4 = [PHAssetCollection fetchAssetCollectionsWithType:type4 subtype:subtype4 options:nil];
    
    // 用户使用 iCloud 共享的相册
    PHAssetCollectionType type5 = PHAssetCollectionTypeAlbum;
    PHAssetCollectionSubtype subtype5 = PHAssetCollectionSubtypeAlbumCloudShared;
    PHFetchResult *album5 = [PHAssetCollection fetchAssetCollectionsWithType:type5 subtype:subtype5 options:nil];
    
    return @[album1, album2, album3, album4, album5];
}

+ (void)displayAlbumArray:(NSArray<PHFetchResult *> *)albums options:(PHFetchOptions *)options result:(void(^)(NSArray<XXAlbumModel *> *albums))block {

    // 初始化相册列表
    NSMutableArray<XXAlbumModel *> *models = [NSMutableArray array];
    
    // 遍历相册列表
    for (PHFetchResult *result in albums) {
        
        // 枚举相册分类
        [result enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 过滤后的相册分类
            PHFetchResult *result = [self filterAlbum:obj options:options];
            if (result != nil) {
                XXAlbumModel *model = [self albumModelWithFetchResult:result collection:obj];
                if (model.isCameraRoll) {
                    [models insertObject:model atIndex:0];
                } else {
                    [models addObject:model];
                }
            }
        }];
    }
    
    // 返回查找结果
    if (block) { block([models copy]); };
}

+ (PHFetchResult *)filterAlbum:(id)obj options:(PHFetchOptions *)options {
    
    // 过滤掉PHCollectionList
    if (![obj isKindOfClass:[PHAssetCollection class]]) {
        return nil;
    }
    
    PHAssetCollection *collection = (PHAssetCollection *)obj;
    
    // 过滤空相册
    if (collection.estimatedAssetCount <= 0 && ![self isCameraRoll:collection]) {
        return nil;
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (result.count <= 0 && ![self isCameraRoll:collection]) {
        return nil;
    }
    
    // 过滤需要隐藏的
    if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) {
        return nil;
    }
    
    // 过滤『最近删除』
    if (collection.assetCollectionSubtype == 1000000201) {
        return nil;
    }
    
    return result;
}

+ (BOOL)isCameraRoll:(PHAssetCollection *)collection {

    // 获取手机系统版本
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *version = [systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (version.length <= 1) {
        version = [version stringByAppendingString:@"00"];
    } else if (version.length <= 2) {
        version = [version stringByAppendingString:@"0"];
    }
    
    // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    CGFloat value = version.floatValue;
    if (value >= 800 && value <= 802) {
        return collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    }

    // 其他
    return collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}

+ (XXAlbumModel *)albumModelWithFetchResult:(PHFetchResult *)result collection:(PHAssetCollection *)collection {
    XXAlbumModel *model = [[XXAlbumModel alloc] init];
    [model setIsCameraRoll:[self isCameraRoll:collection]];
    [model setName:collection.localizedTitle];
    [model setResult:result];
    return model;
}


#pragma mark - 获取相片列表

// 获取相片列表
+ (void)fetchPhotos:(XXImagePickerConfigure *)configure album:(XXAlbumModel *)album result:(void(^)(NSArray<XXPhotoModel *> *photos))block {
 
    // 相片列表
    NSMutableArray<XXPhotoModel *> *models = [NSMutableArray array];
    
    // 枚举相片集合，获取需要的相片
    [album.result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = [self filterPhoto:obj configure:configure];
        if (asset != nil) {
            [models addObject:[self photoModelWithAsset:asset]];
        }
    }];
    
    // 返回结果
    if (block) { block([models copy]); }
}

+ (PHAsset *)filterPhoto:(id)obj configure:(XXImagePickerConfigure *)configure {
    
    // 过滤掉PHCollectionList
    if (![obj isKindOfClass:[PHAsset class]]) {
        return nil;
    }
    
    PHAsset *asset = (PHAsset *)obj;
    
    // 不满足类型
    if (!configure.isAllowVideo && asset.mediaType == PHAssetMediaTypeVideo) {
        return nil;
    }
    
    if (!configure.isAllowImage && asset.mediaType == PHAssetMediaTypeImage) {
        return nil;
    }
    
    // 不满足尺寸要求
    if (asset.pixelWidth < configure.minWidth || asset.pixelHeight < configure.minHeight) {
        return nil;
    }
    
    return asset;
}


+ (XXPhotoModel *)photoModelWithAsset:(PHAsset *)asset {
    XXPhotoModel *model = [[XXPhotoModel alloc] init];
    [model setAsset:asset];
    return model;
}


#pragma mark - 获取缩略图

// 获取缩略图
+ (void)fetchThumbnailImage:(XXPhotoModel *)model targetSize:(CGSize)targetSize result:(void(^)(UIImage *image, BOOL isCloud))block {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeOpportunistic];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:NO];
    [options setSynchronous:YES];
    
    // 下载缩略图
    void(^downloadThumbnailBlock)(BOOL isCloud) = ^(BOOL isCloud) {
        
        // 获取缩略图
        [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
          
            // 已经加载过缩略图
            [model setIsExistThumbnail:YES];
            
            // 主线程返回
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) { block(result, isCloud); }
            });
        }];
    };
    
    dispatch_queue_t queue = dispatch_queue_create("gcd_queue_download", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        // 如果已经下载过，直接加载缩略图
        if (model.isExistThumbnail) {
            // 下载缩略图
            downloadThumbnailBlock(!model.isExistOriginal);
        }
        // 未下载过，先判断是否存在原图
        else {
            
            [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:model.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                
                // 是否在iCloud
                BOOL isCloud = [[info objectForKey:PHImageResultIsInCloudKey] boolValue];
                // 缓存本地是否存在原图
                [model setIsExistOriginal:!isCloud];

                // 下载缩略图
                downloadThumbnailBlock(isCloud);
            }];
        }
    });
}


#pragma mark - 获取原图

// 获取原图
+ (void)fetchOriginalImage:(XXPhotoModel *)model progress:(void(^)(CGFloat progress))progressBlock result:(void(^)(UIImage *image))block {
    
    dispatch_queue_t queue = dispatch_queue_create("gcd_queue_download", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        [options setDeliveryMode:PHImageRequestOptionsDeliveryModeOpportunistic];
        [options setResizeMode:PHImageRequestOptionsResizeModeFast];
        [options setNetworkAccessAllowed:YES];
        [options setSynchronous:YES];
        
        [options setProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error && progressBlock) { progressBlock(progress); }
            });
        }];
        
        [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:model.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            
            if (imageData.length > 0) {
                
                // 缓存本地是否存在原图
                [model setIsExistOriginal:YES];

                // 返回原图
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) { block([UIImage imageWithData:imageData]); }
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) { block(nil); }
                });
            }
        }];
    });
    
}

@end
