//
//  XXPhotoCell.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXPhotoModel;
@class XXPhotoCell;
@class XXProgressView;

@protocol XXPhotoCellDelegate <NSObject>

@optional
// 选择、取消
- (void)photoCell:(XXPhotoCell *)cell didSelected:(XXPhotoModel *)photo;
// 是否允许选择
- (BOOL)photoCell:(XXPhotoCell *)cell isAllowSelect:(XXPhotoModel *)photo;

@end

/**
 相片Cell
 */
@interface XXPhotoCell : UICollectionViewCell

// 代理
@property (nonatomic, weak) id<XXPhotoCellDelegate> delegate;
// 缩略图片
@property (nonatomic, strong) UIImageView *thumbnailImageView;
// 中间播放图标（针对视频）
@property (nonatomic, strong) UIImageView *playImageView;
// 右上角状态按钮
@property (nonatomic, strong) UIButton *statusButton;
// 右上角选中计数
@property (nonatomic, strong) UILabel *countLabel;
// 不可操作遮照
@property (nonatomic, strong) UIView *unableMaskView;
// 下载进度视图
@property (nonatomic, strong) XXProgressView *progressView;

// 相片模型
@property (nonatomic, weak) XXPhotoModel *photo;
// 需要展示的图片尺寸（1x)，建议传入cell的宽高
@property (nonatomic, assign) CGSize displaySize;

@end

NS_ASSUME_NONNULL_END
