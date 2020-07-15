//
//  ViewController.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "ViewController.h"
#import "XXImagePicker-Header.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBoundes = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setCenter:CGPointMake(CGRectGetWidth(screenBoundes)/2, CGRectGetWidth(screenBoundes)/2)];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    
    // 配置
    XXImagePickerConfigure *configure = [XXImagePickerConfigure defaultConfigure];
    
    // 跳转
    XXImagePickerController *pickerVc = [[XXImagePickerController alloc] initWithConfigure:configure];
    [self presentViewController:pickerVc animated:YES completion:nil];
}


@end
