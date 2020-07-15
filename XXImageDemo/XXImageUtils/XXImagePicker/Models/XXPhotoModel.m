//
//  XXPhotoModel.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Photos/Photos.h>
#import "XXImageManager.h"
#import "XXPhotoModel.h"

@implementation XXPhotoModel

- (void)setIsDownloading:(BOOL)isDownloading {
    
    _isDownloading = isDownloading;
    
    if (isDownloading) {
        
        if (self.downloadBlock) {
            self.downloadBlock(NO, 0.f, nil);
        }
        
        __weak typeof(self) weakSelf = self;
        [XXImageManager fetchOriginalImage:self progress:^(CGFloat progress) {
            
            if (weakSelf.downloadBlock) {
                weakSelf.downloadBlock(NO, progress, nil);
            }
            
        } result:^(UIImage * _Nonnull image) {
            
            [weakSelf setIsDownloading:NO];
            
            if (weakSelf.downloadBlock) {
                weakSelf.downloadBlock(YES, 1.0, image);
            }
        }];
    }
}

- (XXPhotoType)type {
    
    if (_asset != nil) {
        // 视频
        if (_asset.mediaType == PHAssetMediaTypeVideo) {
            return XXPhotoTypeVideo;
        }
        // 音频
        else if (_asset.mediaType == PHAssetMediaTypeAudio) {
            return XXPhotoTypeVoice;
        }
        // 图片
        else if (_asset.mediaType == PHAssetMediaTypeImage) {
            
            // GIF
            if ([[_asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                return XXPhotoTypeGif;
            }
            
            return XXPhotoTypeImage;
        }
    }
    return XXPhotoTypeUnkown;
}


- (NSTimeInterval)duration {
    if (self.type == XXPhotoTypeVideo) {
        return _asset.duration;
    }
    return 0.f;
}

@end
