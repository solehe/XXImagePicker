//
//  XXUtils.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/31.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXUtils : NSObject

// 生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
