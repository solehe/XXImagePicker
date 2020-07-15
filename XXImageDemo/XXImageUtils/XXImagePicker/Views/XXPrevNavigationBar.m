//
//  XXPrevNaviBar.m
//  XXImageDemo
//
//  Created by solehe on 2020/7/15.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXPrevNavigationBar.h"
#import "XXImageMacro.h"

@implementation XXPrevNavigationBar

#pragma mark - 初始化

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton setImage:[UIImage imageNamed:@"image_picker_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setBackgroundColor:[UIColor clearColor]];
        [_selectButton setImage:[UIImage imageNamed:@"image_picker_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"image_picker_selected"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return _selectButton;
}

#pragma mark - action

- (void)backAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(prevNavigationBarDidClickedBack:)]) {
        [self.delegate prevNavigationBarDidClickedBack:self];
    }
}

- (void)selectAction:(UIButton *)button {
    [button setSelected:!button.selected];
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 调整布局
    [self.backButton setFrame:CGRectMake(0, SAFEAREA_TOP_HEIGHT, 44, H(self)-SAFEAREA_TOP_HEIGHT)];
    [self.titleLabel setFrame:CGRectMake(60, SAFEAREA_TOP_HEIGHT, W(self)-120, H(self)-SAFEAREA_TOP_HEIGHT)];
    [self.selectButton setFrame:CGRectMake(W(self)-44, SAFEAREA_TOP_HEIGHT, 44, H(self)-SAFEAREA_TOP_HEIGHT)];
}

// iOS11后需要重写该方法以保证正常显示
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
