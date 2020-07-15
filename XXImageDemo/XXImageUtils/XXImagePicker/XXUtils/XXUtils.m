//
//  XXUtils.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/31.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImageMacro.h"
#import "XXUtils.h"

@implementation XXUtils

// 生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, SCREEN_SCALE);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
