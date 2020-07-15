//
//  XXAlbumCell.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XXAlbumModel;

/**
 相册列表Cell
 */
@interface XXAlbumCell : UITableViewCell

// 缩略图片
@property (nonatomic, strong) UIImageView *thumbnailImageView;
// 标题
@property (nonatomic, strong) UILabel *nameLabel;
// 分割线
@property (nonatomic, strong) UIView *lineView;

// 相册模型
@property (nonatomic, weak) XXAlbumModel *album;

@end

NS_ASSUME_NONNULL_END
