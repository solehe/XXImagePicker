//
//  XXAlbumPickerController.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImageMacro.h"
#import "XXAlbumPickerController.h"
#import "XXImagePickerConfigure.h"
#import "XXImageManager.h"
#import "XXAlbumModel.h"
#import "XXAlbumCell.h"

#define XXAlbumCellRowHeight 70.f

@interface XXAlbumPickerController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 容器视图
@property (nonatomic, strong) UIView *contentView;
// 相册列表
@property (nonatomic, strong) UITableView *tableView;
// 相册集合
@property (nonatomic, copy) NSArray<XXAlbumModel *> *albums;
// 当前选中位置
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation XXAlbumPickerController

#pragma mark - 初始化

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backgroundView setBackgroundColor:RGB16(0x333333)];
        [_backgroundView setAlpha:0.f];
        [self.view insertSubview:_backgroundView atIndex:0];
    }
    return _backgroundView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:RGBA(0xFF, 0xFF, 0xFF, 0.8)];
        [_contentView.layer setMasksToBounds:YES];
        [self.view addSubview:_contentView];
        
        // 底部圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        [maskLayer setFrame:self.tableView.bounds];
        [maskLayer setPath:maskPath.CGPath];
        [_contentView.layer setMask:maskLayer];
        
        // 模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setFrame:CGRectMake(0, 0, W(self.tableView), H(self.tableView))];
        [_contentView addSubview:effectview];
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setFrame:CGRectMake(0, 0, W(self.view), H(self.view)-SAFEAREA_BOTTOM_HEIGHT-40.f)];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:XXAlbumCellRowHeight];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setRowHeight:60.f];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure delegate:(nonnull id<XXAlbumPickerControllerDelegate>)delegate {
    if (self = [super init]) {
        
        [self setDelegate:delegate];
        
        __weak typeof(self) weakSelf = self;
        [XXImageManager fetchAlbums:configure result:^(NSArray<XXAlbumModel *> * _Nonnull albums) {
            [weakSelf setAlbums:albums];
            [weakSelf changeSelectedAlbum:0];
        }];
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self initUI];
}

#pragma mark - UI初始化
- (void)initUI {
    
    // 注册cell
    [self.tableView registerClass:[XXAlbumCell class] forCellReuseIdentifier:@"XXAlbumCell"];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAlbumCell"];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setAlbum:self.albums[indexPath.row]];
    
    if (indexPath.row == self.selectedIndex) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 标记选中位置
    [self setSelectedIndex:indexPath.row];
    [tableView reloadData];
    
    // 切换相册
    if ([self.delegate respondsToSelector:@selector(albumPickerController:didSelectedAlbum:)]) {
        [self.delegate albumPickerController:self didSelectedAlbum:self.albums[indexPath.row]];
    }
}

#pragma mark - 外部调用方法
- (void)show:(void(^)(void))compelete {
    [self.backgroundView setAlpha:0.f];
    [self.contentView setAlpha:0.5f];
    [self.contentView setFrame:CGRectMake(0, -H(self.view), W(self.view), H(self.view)-SAFEAREA_BOTTOM_HEIGHT-40.f)];
    [UIView animateWithDuration:0.25 animations:^{
        [self.backgroundView setAlpha:0.2f];
        [self.contentView setAlpha:1.f];
        [self.contentView setFrame:CGRectMake(0, 0, W(self.view), H(self.view)-SAFEAREA_BOTTOM_HEIGHT-40.f)];
    } completion:^(BOOL finished) {
        if (compelete) { compelete(); }
    }];
}

- (void)hidden:(void(^)(void))compelete {
    [UIView animateWithDuration:0.25 animations:^{
        [self.backgroundView setAlpha:0.f];
        [self.contentView setAlpha:0.f];
        [self.contentView setFrame:CGRectMake(0, -H(self.view), W(self.view), H(self.view)-SAFEAREA_BOTTOM_HEIGHT-40.f)];
    } completion:^(BOOL finished) {
        if (compelete) { compelete(); }
    }];
}

#pragma mark - 私有方法
- (void)changeSelectedAlbum:(NSUInteger)index {
    if (self.albums.count > 0 && index < self.albums.count) {
        if ([self.delegate respondsToSelector:@selector(albumPickerController:didSelectedAlbum:)]) {
            [self.delegate albumPickerController:self didSelectedAlbum:self.albums[index]];
        }
    }
}

@end
