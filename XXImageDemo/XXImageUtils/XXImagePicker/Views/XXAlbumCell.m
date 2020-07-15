//
//  XXAlbumCell.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXImageManager.h"
#import "XXImageMacro.h"
#import "XXAlbumCell.h"
#import "XXAlbumModel.h"

@implementation XXAlbumCell

#pragma mark - 初始化

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        [_thumbnailImageView setBackgroundColor:[UIColor clearColor]];
        [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_thumbnailImageView setClipsToBounds:YES];
        [self addSubview:_thumbnailImageView];
    }
    return _thumbnailImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.f weight:UIFontWeightMedium]];
        [_nameLabel setTextColor:RGB16(0x333333)];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:RGBA(0x55, 0x55, 0x55, 0.1)];
        [self addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - 数据

- (void)setAlbum:(XXAlbumModel *)album {
    _album = album;
    
    // 刷新界面
    [self refreshUI];
}

- (void)refreshUI {
    
    __weak typeof(self) weakSelf = self;
    CGSize size = CGSizeMake(H(self), H(self));
    [XXImageManager fetchThumbnailImage:self.album.photos[0] targetSize:size result:^(UIImage * _Nonnull image, BOOL isCloud) {
        [weakSelf.thumbnailImageView setImage:image];
    }];
    
    // 标题
    NSString *name = [NSString stringWithFormat:@"%@ (%@)", self.album.name, @(self.album.count)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name];
    NSRange range = NSMakeRange(self.album.name.length, name.length-self.album.name.length);
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : RGB16(0xAAAAAA),
        NSFontAttributeName : [UIFont systemFontOfSize:15.f]
    };
    [attributedString setAttributes:attributes range:range];
    [self.nameLabel setAttributedText:attributedString];
}

#pragma marl - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新布局
    [self.thumbnailImageView setFrame:CGRectMake(0, 0, H(self), H(self))];
    [self.nameLabel setFrame:CGRectMake(H(self)+15, 0, W(self)-120, H(self))];
    [self.lineView setFrame:CGRectMake(0, H(self)-0.5, W(self), 0.5)];
}

@end
