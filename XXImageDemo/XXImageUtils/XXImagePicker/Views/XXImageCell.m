//
//  XXImageCell.m
//  XXImageDemo
//
//  Created by solehe on 2020/7/15.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImageCell.h"
#import "XXPhotoModel.h"
#import "XXImageMacro.h"
#import "XXImageManager.h"

@implementation XXImageCell

#pragma mark - 初始化

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - 数据

- (void)setPhoto:(XXPhotoModel *)photo {
    _photo = photo;
    
    // 刷新UI展示
    [self refreshUI];
}

- (void)refreshUI {
    
    // 获取原图
    [XXImageManager fetchOriginalImage:self.photo progress:^(CGFloat progress) {
        
    } result:^(UIImage * _Nonnull image) {
        
        // 更新展示图片
        [self.imageView setImage:image];
        
    }];
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新布局
    [self.imageView setFrame:CGRectMake(0, 0, W(self), H(self))];
}

@end
