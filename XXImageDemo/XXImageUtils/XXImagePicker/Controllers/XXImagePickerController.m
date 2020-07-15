//
//  XXImagePickerController.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImagePickerController.h"
#import "XXAlbumPickerController.h"
#import "XXPhotoPickerController.h"
#import "XXImagePrevViewController.h"
#import "XXImageCropViewController.h"
#import "XXImagePickerConfigure.h"
#import "XXImageMacro.h"

@interface XXImagePickerController ()

@end

@implementation XXImagePickerController

#pragma mark - 初始化

// 根据XXImagePickerConfigure初始化
- (instancetype)initWithConfigure:(XXImagePickerConfigure *)configure {
 
    switch (configure.pickerType)
    {
        case XXImagePickerTypeDefault:
        {
            XXPhotoPickerController *pickerVc = [[XXPhotoPickerController alloc] initWithConfigure:configure];
            return [super initWithRootViewController:pickerVc];
        }
            
        case XXImagePickerTypePrev:
        {
            XXImagePrevViewController *prevVc = [[XXImagePrevViewController alloc] initWithConfigure:configure];
            return [super initWithRootViewController:prevVc];
        }
        
        case XXImagePickerTypeCrop:
        {
            XXImageCropViewController *cropVc = [[XXImageCropViewController alloc] init];
            return [super initWithRootViewController:cropVc];
        }
            
        default:
            return nil;
    }
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - 其他
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

@end
