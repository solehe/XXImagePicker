//
//  XXImageCell.h
//  XXImageDemo
//
//  Created by solehe on 2020/7/15.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXPhotoModel;

NS_ASSUME_NONNULL_BEGIN

/**
 图片Cell
 */
@interface XXImageCell : UICollectionViewCell

// 图片展示视图
@property (nonatomic, strong) UIImageView *imageView;

// 相片模型
@property (nonatomic, weak) XXPhotoModel *photo;

@end

NS_ASSUME_NONNULL_END
