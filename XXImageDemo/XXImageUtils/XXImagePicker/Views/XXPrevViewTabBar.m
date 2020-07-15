//
//  XXPreviewTabBar.m
//  XXImageDemo
//
//  Created by solehe on 2020/4/21.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXPrevViewTabBar.h"
#import "XXImageMacro.h"
#import "XXUtils.h"

@interface XXPrevViewTabBar ()

// 父视图
@property (nonatomic, strong) UIView *contentView;
// 预览
@property (nonatomic, strong) UIButton *editButton;
// 原图
@property (nonatomic, strong) UIButton *originButton;
// 发送
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation XXPrevViewTabBar

#pragma mark - 初始化

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [[UIButton alloc] init];
        [_editButton setBackgroundColor:[UIColor clearColor]];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:RGBA(0x55, 0x55, 0x55, 0x55) forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]];
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editButton];
    }
    return _editButton;
}

- (UIButton *)originButton {
    if (!_originButton) {
        _originButton = [[UIButton alloc] init];
        [_originButton setBackgroundColor:[UIColor clearColor]];
        [_originButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originButton setImage:[UIImage imageNamed:@"image_picker_origin_normal"] forState:UIControlStateNormal];
        [_originButton setImage:[UIImage imageNamed:@"image_picker_origin_selected"] forState:UIControlStateSelected];
        [_originButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [_originButton setTitleColor:RGBA(0x55, 0x55, 0x55, 0x55) forState:UIControlStateNormal];
        [_originButton.titleLabel setFont:[UIFont systemFontOfSize:14.f weight:UIFontWeightMedium]];
        [_originButton addTarget:self action:@selector(originAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_originButton];
    }
    return _originButton;
}

- (UIButton *)sendButton {
    
    if (!_sendButton) {
        
        _sendButton = [[UIButton alloc] init];
        [_sendButton setBackgroundColor:[UIColor clearColor]];
        [_sendButton setImage:[UIImage imageNamed:@"image_picker_send"] forState:UIControlStateNormal];
        
        // 设置默认背景
        UIImage *normalImage = [XXUtils imageWithColor:RGB16(0xADAFB3) size:CGSizeMake(36, 36)];
        [_sendButton setBackgroundImage:normalImage forState:UIControlStateDisabled];
        
        // 设置选中选中背景
        UIImage *selectedImage = [XXUtils imageWithColor:RGB16(0x29C449) size:CGSizeMake(36, 36)];
        [_sendButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
        
        [_sendButton.layer setCornerRadius:18.f];
        [_sendButton.layer setMasksToBounds:YES];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setEnabled:NO];
        [self.contentView addSubview:_sendButton];
    }
    
    return _sendButton;
}

#pragma mark - action

- (void)editAction:(UIButton *)button {
//    if ([self.delegate respondsToSelector:@selector(pickerTabBarDidClickPreview:)]) {
//        [self.delegate pickerTabBarDidClickPreview:self];
//    }
}

- (void)originAction:(UIButton *)button {
    
    [button setSelected:!button.selected];
    
//    if ([self.delegate respondsToSelector:@selector(pickerTabBar:didSelectedOrigin:)]) {
//        [self.delegate pickerTabBar:self didSelectedOrigin:button.selected];
//    }
}

- (void)sendAction:(UIButton *)button {
//    if ([self.delegate respondsToSelector:@selector(pickerTabBarDidClickSend:)]) {
//        [self.delegate pickerTabBarDidClickSend:self];
//    }
}

#pragma mark - 外部调用方法

// 相片选中个数变了
- (void)setSelectedPhotoCount:(NSUInteger)count {
    [self.editButton setEnabled:(count>0)];
    [self.sendButton setEnabled:(count>0)];
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新布局
    [self.contentView setFrame:CGRectMake(0, 0, W(self), 60)];
    [self.editButton setFrame:CGRectMake(6, 0, 60, H(self.contentView))];
    [self.originButton setFrame:CGRectMake(0, 0, 80, H(self.contentView))];
    [self.originButton setCenter:CGPointMake(W(self)/2, H(self.contentView)/2)];
    [self.sendButton setFrame:CGRectMake(W(self)-56, 12, 36, 36)];
}

@end
