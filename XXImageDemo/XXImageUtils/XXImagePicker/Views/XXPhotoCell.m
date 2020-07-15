//
//  XXPhotoCell.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Photos/Photos.h>

#import "XXImageManager.h"
#import "XXImageMacro.h"
#import "XXProgressView.h"
#import "XXPhotoCell.h"
#import "XXPhotoModel.h"

@implementation XXPhotoCell

#pragma mark - 初始化

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        [_thumbnailImageView setBackgroundColor:[UIColor clearColor]];
        [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_thumbnailImageView setClipsToBounds:YES];
        [self insertSubview:_thumbnailImageView belowSubview:self.countLabel];
    }
    return _thumbnailImageView;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [[UIButton alloc] init];
        [_statusButton setBackgroundColor:[UIColor clearColor]];
        [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusButton];
    }
    return _statusButton;
}

- (UIView *)unableMaskView {
    if (!_unableMaskView) {
        _unableMaskView = [[UIView alloc] init];
        [_unableMaskView setBackgroundColor:RGBA(0xFF, 0xFF, 0xFF, 0.7)];
        [self insertSubview:_unableMaskView aboveSubview:self.thumbnailImageView];
    }
    return _unableMaskView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        [_playImageView setBackgroundColor:[UIColor clearColor]];
        [_playImageView setImage:[UIImage imageNamed:@"image_picker_video"]];
        [_playImageView setHidden:YES];
        [self insertSubview:_playImageView aboveSubview:self.thumbnailImageView];
    }
    return _playImageView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setBackgroundColor:RGB16(0x29C449)];
        [_countLabel setTextColor:[UIColor whiteColor]];
        [_countLabel setFont:[UIFont systemFontOfSize:12.f weight:UIFontWeightMedium]];
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [_countLabel.layer setCornerRadius:10.f];
        [_countLabel.layer setMasksToBounds:YES];
        [_countLabel setHidden:YES];
        [self insertSubview:_countLabel belowSubview:self.statusButton];
    }
    return _countLabel;
}

- (XXProgressView *)progressView {
    if (!_progressView && self.photo && !self.photo.isExistOriginal) {
        _progressView = [[XXProgressView alloc] init];
        [_progressView setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    }
    return _progressView;
}

#pragma mark - action

- (void)clickAction:(UIButton *)button {
    
    if (![self.delegate respondsToSelector:@selector(photoCell:isAllowSelect:)]) {
        return;
    }
    
    if (![self.delegate photoCell:self isAllowSelect:self.photo]) {
        return;
    }
    
    if (self.photo.isExistOriginal) { //选择
        
        // 改变选中状态
        [self.photo setSelected:!self.photo.isSelected];
        // 回调
        if ([self.delegate respondsToSelector:@selector(photoCell:didSelected:)]) {
            [self.delegate photoCell:self didSelected:self.photo];
        }
        // 刷新UI
        [self refreshStatus:YES];
        
    } else { //下载
        
        [self.photo setIsDownloading:YES];
        [self refreshStatus:NO];
    }
}

#pragma mark - 数据

- (void)setPhoto:(XXPhotoModel *)photo {
    _photo = photo;
    
    // 刷新UI展示
    [self refreshUI];
}

- (void)refreshUI {
    
    // 获取缩略图
    [XXImageManager fetchThumbnailImage:self.photo targetSize:self.displaySize result:^(UIImage * _Nonnull image, BOOL isCloud) {
        
        // 更新展示图片
        [self.thumbnailImageView setImage:image];
        
        // 是否是视频
        [self.playImageView setHidden:(self.photo.type != XXPhotoTypeVideo)];
        
        // 更新状态
        [self refreshStatus:NO];
    }];
}

- (void)refreshStatus:(BOOL)animation {
    
    // 选中
    if (self.photo.isSelected) {
        
        [self.statusButton setImage:nil forState:UIControlStateNormal];
        [self.unableMaskView setHidden:YES];
        [self.countLabel setHidden:NO];
        
        if (animation) {
            [self execSpringAnimation];
        }
    }
    // 未选中
    else {
        // 更新状态图片
        if (!self.photo.isExistOriginal) {
            [self.statusButton setImage:[UIImage imageNamed:@"image_picker_icloud"] forState:UIControlStateNormal];
            [self.unableMaskView setHidden:NO];
        } else {
            [self.statusButton setImage:[UIImage imageNamed:@"image_picker_normal"] forState:UIControlStateNormal];
            [self.unableMaskView setHidden:YES];
        }
        [self.countLabel setHidden:YES];
    }
    
    // 下载监听
    if (!self.photo.isDownloading) {
        
        [self.statusButton setHidden:NO];
        [self.progressView removeFromSuperview];
        
    } else {
        
        [self.statusButton setHidden:YES];
        [self insertSubview:self.progressView aboveSubview:self.thumbnailImageView];
        
        __weak typeof(self) weakSelf = self;
        [self.photo setDownloadBlock:^(BOOL finished, CGFloat progress, UIImage * _Nonnull image) {
            if (!finished) {
                [weakSelf.progressView setProgress:progress];
            } else {
                [weakSelf refreshStatus:NO];
            }
        }];
    }
    
}

#pragma mark - 私有方法

- (void)execSpringAnimation {
    [self.countLabel setBounds:CGRectZero];
    [UIView animateWithDuration:0.5f delay:0.f usingSpringWithDamping:0.5f
          initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.countLabel setBounds:CGRectMake(0, 0, 20, 20)];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新布局
    [self.thumbnailImageView setFrame:self.bounds];
    [self.statusButton setFrame:CGRectMake(W(self)-30, 0, 30, 30)];
    [self.unableMaskView setFrame:self.bounds];
    [self.playImageView setFrame:CGRectMake(5, H(self)-20, 15, 15)];
    [self.countLabel setFrame:CGRectMake(W(self)-25, 5, 20, 20)];
    [self.progressView setFrame:self.bounds];
}

@end
