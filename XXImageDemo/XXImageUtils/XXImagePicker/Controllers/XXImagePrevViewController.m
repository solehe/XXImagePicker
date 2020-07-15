//
//  XXImagePrevViewController.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImagePrevViewController.h"
#import "XXCollectionView.h"
#import "XXPrevNavigationBar.h"
#import "XXPrevViewTabBar.h"
#import "XXPrevPickerView.h"
#import "XXImageCell.h"
#import "XXPhotoModel.h"
#import "XXImageMacro.h"
#import "XXImagePickerConfigure.h"

@interface XXImagePrevViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    XXPrevNavigationBarDelegate
>

// 导航栏
@property (nonatomic, strong) XXPrevNavigationBar *navigationBar;
// 工具栏
@property (nonatomic, strong) XXPrevViewTabBar *prevViewTabBar;
// 相册列表
@property (nonatomic, strong) XXCollectionView *collectionView;
//

@end

@implementation XXImagePrevViewController

#pragma mark - getter

// 导航栏
- (XXPrevNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[XXPrevNavigationBar alloc] init];
        [_navigationBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNAVIBAR_HEIGHT)];
        [_navigationBar setBackgroundColor:[UIColor clearColor]];
        [_navigationBar setDelegate:self];
        [self.view insertSubview:_navigationBar aboveSubview:self.prevViewTabBar];
        
        // 模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setFrame:CGRectMake(0, 0, W(_navigationBar), H(_navigationBar))];
        [_navigationBar addSubview:effectview];
    }
    return _navigationBar;
}

// 工具栏
- (XXPrevViewTabBar *)prevViewTabBar {
    if (!_prevViewTabBar) {
        _prevViewTabBar = [[XXPrevViewTabBar alloc] init];
        [_prevViewTabBar setBackgroundColor:[UIColor clearColor]];
        [_prevViewTabBar setFrame:CGRectMake(0, H(self.view)-kTABBAR_HEIGHT, SCREEN_WIDTH, kTABBAR_HEIGHT)];
        [self.view addSubview:_prevViewTabBar];
        
        // 模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setFrame:CGRectMake(0, 0, W(_prevViewTabBar), H(_prevViewTabBar))];
        [_prevViewTabBar addSubview:effectview];
    }
    return _prevViewTabBar;
}

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure {
    return [self initWithConfigure:configure delegate:nil];
}

- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure
                         delegate:(id<XXImagePrevViewControllerDelegate> __nullable)delegate {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - 生命周期方法

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏系统导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 恢复系统导航栏
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initUI];
}

#pragma mark - 初始化UI

- (void)initUI {
    
    // 设置标题
    [self.navigationBar.titleLabel setText:nil];
    
    // 列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setItemSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [layout setMinimumInteritemSpacing:0.f];
    [layout setMinimumLineSpacing:0.f];
    
    _collectionView = [[XXCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setAlwaysBounceHorizontal:NO];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [self.view insertSubview:_collectionView belowSubview:self.prevViewTabBar];
    
    // 注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_collectionView registerClass:[XXImageCell class] forCellWithReuseIdentifier:@"XXImageCell"];
    
    //注意：iOS11以下的系统，所在的controller最好设置automaticallyAdjustsScrollViewInsets为NO，不然就会随导航栏或状态栏的变化产生偏移
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
#pragma clang diagnostic pop
    }
    
    // 滑动到点击位置
    [self scrollToPhoto:self.currentPhoto];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 相片模型
    XXPhotoModel *photo = self.photos[indexPath.row];
     
    // 相片cell
    if (photo.type == XXPhotoTypeImage) {
        XXImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XXImageCell" forIndexPath:indexPath];
        [cell setPhoto:photo];
        return cell;
    }
    // 其他
    else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - 内部方法

// 滑动到指定位置
- (void)scrollToPhoto:(XXPhotoModel *)photo {
    if ([self.photos containsObject:photo]) {
        NSUInteger index = [self.photos indexOfObject:photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


#pragma mark - XXPrevNavigationBarDelegate

- (void)prevNavigationBarDidClickedBack:(XXPrevNavigationBar *)naviBar {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
