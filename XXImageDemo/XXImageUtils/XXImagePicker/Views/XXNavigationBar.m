//
//  XXPhotoPickerNavigationBar.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/29.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImageMacro.h"
#import "XXNavigationBar.h"

@implementation XXNavigationBar

#pragma mark - 初始化UI

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB16(0x333333) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [[UIButton alloc] init];
        [_menuButton setBackgroundColor:RGB16(0x555555)];
        [_menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_menuButton setImage:[UIImage imageNamed:@"image_picker_arrow"] forState:UIControlStateNormal];
        [_menuButton.titleLabel setFont:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]];
        [_menuButton.layer setCornerRadius:15.f];
        [_menuButton.layer setMasksToBounds:YES];
        [_menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_menuButton];
    }
    return _menuButton;
}

#pragma mark - 外部方法

// 切换标题
- (void)setTitle:(NSString *)title {
    [self.menuButton setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}

// 改变选中状态
- (void)setSelected:(BOOL)selected {
    
    // 改变选中状态
    [self.menuButton setSelected:selected];
    
    // 箭头旋转动画
    [UIView animateWithDuration:0.2f animations:^{
        NSInteger num = self.menuButton.selected ? 1 : 0;
        [self.menuButton.imageView setTransform:CGAffineTransformMakeRotation(M_PI * num)];
    }];

    // 代理回调
    if ([self.delegate respondsToSelector:@selector(navigationBar:didSelected:)]) {
        [self.delegate navigationBar:self didSelected:self.menuButton.selected];
    }
}

#pragma mark - action

- (void)cancelAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(navigationBarDidCancel:)]) {
        [self.delegate navigationBarDidCancel:self];
    }
}

- (void)menuAction:(UIButton *)button {
    [self setSelected:!button.selected];
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 重新布局
    [self.cancelButton setFrame:CGRectMake(0, 0, 60, H(self))];
    
    // 计算标题宽度
    CGFloat width = [self.menuButton.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-100, 30)].width;
    CGFloat menuWidth = width + 10 + 35;
    
    [self.menuButton setFrame:CGRectMake(0, 0, menuWidth, 30)];
    [self.menuButton setCenter:CGPointMake(W(self)/2, H(self)/2)];
    [self.menuButton setImageEdgeInsets:UIEdgeInsetsMake(0, menuWidth-25, 0, 0)];
    [self.menuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
}

// iOS11后需要重写该方法以保证正常显示
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
