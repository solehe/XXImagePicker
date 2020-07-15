//
//  XXImagePickerConfigure.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImagePickerConfigure.h"

@implementation XXImagePickerConfigure

// 默认配置
+ (XXImagePickerConfigure *)defaultConfigure {
    
    XXImagePickerConfigure *configure = [[XXImagePickerConfigure alloc] init];
    
    [configure setPickerType:XXImagePickerTypeDefault];
    [configure setIsAllowImage:YES];
    [configure setIsAllowVideo:YES];
    [configure setAscending:YES];
    
    [configure setMaxCount:9];
    
    [configure setItemMargin:5.f];
    [configure setColumnCount:4];
    
    return configure;
}

@end
