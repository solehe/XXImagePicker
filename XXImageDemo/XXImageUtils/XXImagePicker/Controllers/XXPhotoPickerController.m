//
//  XXPhotoPickerViewController.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Photos/Photos.h>

#import "XXImagePrevViewController.h"
#import "XXPhotoPickerController.h"
#import "XXAlbumPickerController.h"
#import "XXImagePickerConfigure.h"
#import "XXCollectionView.h"
#import "XXNavigationBar.h"
#import "XXPickerTabBar.h"
#import "XXPhotoCell.h"
#import "XXAlbumModel.h"
#import "XXPhotoModel.h"
#import "XXImageManager.h"
#import "XXImageMacro.h"


@interface XXPhotoPickerController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    XXNavigationBarDelegate,
    XXAlbumPickerControllerDelegate,
    XXPhotoCellDelegate,
    XXPickerTabBarDelegate
>

// 相册列表
@property (nonatomic, strong) XXAlbumPickerController *albumPickerVc;
// 导航栏
@property (nonatomic, strong) XXNavigationBar *navigationBar;
// 工具栏
@property (nonatomic, strong) XXPickerTabBar *pickerTabBar;
// 配置数据
@property (nonatomic, strong) XXImagePickerConfigure *configure;
// 相片列表
@property (nonatomic, strong) XXCollectionView *collectionView;
// 相册模型
@property (nonatomic, strong) XXAlbumModel *album;
// 相片展示宽高
@property (nonatomic, assign) CGFloat itemWH;
// 选中的相片集合
@property (nonatomic, strong) NSMutableArray<XXPhotoModel *> *selectedPhotos;

@end

@implementation XXPhotoPickerController

#pragma mark - getter

// 导航栏
- (XXNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[XXNavigationBar alloc] init];
        [_navigationBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_navigationBar setBackgroundColor:[UIColor clearColor]];
        [_navigationBar setDelegate:self];
        [self.navigationItem setTitleView:_navigationBar];
    }
    return _navigationBar;
}

// 工具栏
- (XXPickerTabBar *)pickerTabBar {
    
    if (!_pickerTabBar) {
        
        _pickerTabBar = [[XXPickerTabBar alloc] init];
        [_pickerTabBar setBackgroundColor:RGBA(0xFF, 0xFF, 0xFF, 0.7)];
        [_pickerTabBar setFrame:CGRectMake(0, H(self.view)-kTABBAR_HEIGHT, SCREEN_WIDTH, kTABBAR_HEIGHT)];
        [_pickerTabBar setDelegate:self];
        [self.view addSubview:_pickerTabBar];
        
        // 模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setFrame:CGRectMake(0, 0, W(_pickerTabBar), H(_pickerTabBar))];
        [_pickerTabBar addSubview:effectview];
    }
    return _pickerTabBar;
}

- (NSMutableArray<XXPhotoModel *> *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (CGFloat)itemWH {
    if (_itemWH <= 0.f) {
        CGFloat width = (SCREEN_WIDTH - (self.configure.columnCount + 1) * self.configure.itemMargin);
        _itemWH = width / self.configure.columnCount;
    }
    return _itemWH;
}

#pragma mark - 初始化

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure {
    if (self = [super init]) {
        _configure = configure;
        // 开始加载相册数据
        _albumPickerVc = [[XXAlbumPickerController alloc] initWithConfigure:configure delegate:self];
    }
    return self;
}

#pragma mark - 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initUI];
}

#pragma mark - 初始化UI
- (void)initUI {
    
    // 隐藏导航栏顶部分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:self.configure.itemMargin];
    [layout setMinimumLineSpacing:self.configure.itemMargin];
    [layout setItemSize:CGSizeMake(self.itemWH, self.itemWH)];
    
    CGFloat margin = self.configure.itemMargin;
    _collectionView = [[XXCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setContentInset:UIEdgeInsetsMake(margin, margin, margin+H(self.pickerTabBar), margin)];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setAlwaysBounceHorizontal:NO];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [self.view insertSubview:_collectionView belowSubview:self.pickerTabBar];
    
    // 注册cell
    [_collectionView registerClass:[XXPhotoCell class] forCellWithReuseIdentifier:@"XXPhotoCell"];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 相片模型
    XXPhotoModel *photo = self.album.photos[indexPath.row];
     
    // 相片cell
    XXPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XXPhotoCell" forIndexPath:indexPath];
    [cell setDisplaySize:CGSizeMake(self.itemWH, self.itemWH)];
    [cell setPhoto:photo];
    [cell setDelegate:self];
    
    // 标记选中顺序
    if (photo.isSelected && [self.selectedPhotos containsObject:photo]) {
        NSUInteger row = [self.selectedPhotos indexOfObject:photo];
        [cell.countLabel setText:[@(row+1) stringValue]];
    } else {
        [cell.countLabel setText:@""];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // 相片模型
    XXPhotoModel *photo = self.album.photos[indexPath.row];
    
    // 跳转到预览页面
    XXImagePrevViewController *prevVc = [[XXImagePrevViewController alloc] initWithConfigure:self.configure];
    [prevVc setPhotos:self.album.photos];
    [prevVc setSelectedPhotos:self.selectedPhotos];
    [prevVc setCurrentPhoto:photo];
    [self.navigationController pushViewController:prevVc animated:YES];
}

#pragma mark - XXPhotoCellDelegate

// 选中、取消处理
- (void)photoCell:(XXPhotoCell *)cell didSelected:(XXPhotoModel *)photo {
    if (photo.isSelected && ![self.selectedPhotos containsObject:photo]) {
        [self.selectedPhotos addObject:photo];
        [self reloadPhoto:photo];
    } else if (!photo.isSelected && [self.selectedPhotos containsObject:photo]) {
        [self.selectedPhotos removeObject:photo];
        [self reloadSelectedPhotos];
    }
    [self.pickerTabBar setSelectedPhotoCount:self.selectedPhotos.count];
}

// 是否允许选择
- (BOOL)photoCell:(XXPhotoCell *)cell isAllowSelect:(XXPhotoModel *)photo {
    if ([self.selectedPhotos containsObject:photo]) {
        return YES;
    }
    return (self.selectedPhotos.count < self.configure.maxCount);
}

#pragma mark - XXNavigationBarDelegate

// 取消、返回
- (void)navigationBarDidCancel:(XXNavigationBar *)bar {
    [self dismissViewControllerAnimated:YES completion:^{
        [XXImageManager deallocManager];
    }];
}

// 切换相册
- (void)navigationBar:(XXNavigationBar *)bar didSelected:(BOOL)selected {
    if (selected) { // 展示菜单
        [self addChildViewController:self.albumPickerVc];
        [self.view addSubview:self.albumPickerVc.view];
        [self.albumPickerVc.view setFrame:self.view.bounds];
        [self.albumPickerVc didMoveToParentViewController:self];
        [self.albumPickerVc show:^{
        }];
    } else { //隐藏菜单
        __weak typeof(self) weakSelf = self;
        [self.albumPickerVc hidden:^{
            [weakSelf.albumPickerVc willMoveToParentViewController:nil];
            [weakSelf.albumPickerVc removeFromParentViewController];
            [weakSelf.albumPickerVc.view removeFromSuperview];
        }];
    }
}

#pragma mark - XXAlbumPickerControllerDelegate

- (void)albumPickerController:(XXAlbumPickerController *)pickerVc didSelectedAlbum:(XXAlbumModel *)album {
    [self.navigationBar setTitle:album.name];
    [self.navigationBar setSelected:NO];
    [self setAlbum:album];
    [self.collectionView reloadData];
}

#pragma mark - XXPickerTabBarDelegate

- (void)pickerTabBarDidClickPreview:(XXPickerTabBar *)bar {
    // 跳转到预览页面
    XXImagePrevViewController *prevVc = [[XXImagePrevViewController alloc] initWithConfigure:self.configure];
    [prevVc setPhotos:[self.selectedPhotos copy]];
    [prevVc setSelectedPhotos:self.selectedPhotos];
    [self.navigationController pushViewController:prevVc animated:YES];
}

- (void)pickerTabBar:(XXPickerTabBar *)bar didSelectedOrigin:(BOOL)origin {
    
}

- (void)pickerTabBarDidClickSend:(XXPickerTabBar *)bar {
    
}

#pragma mark - 私有方法

// 根据相片模型刷新某行
- (void)reloadPhoto:(XXPhotoModel *)photo {
    if ([self.album.photos containsObject:photo]) {
        NSUInteger row = [self.album.photos indexOfObject:photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

// 刷新当前相册选中的行
- (void)reloadSelectedPhotos {
    if (self.selectedPhotos.count > 0) {
        __weak typeof(self) weakSelf = self;
        [self.selectedPhotos enumerateObjectsUsingBlock:^(XXPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger row = [weakSelf.album.photos indexOfObject:obj];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            XXPhotoCell *cell = (XXPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            [cell.countLabel setText:[@(idx+1) stringValue]];
        }];
    }
}
@end
