//
//  XXImagePickerConfigure.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XXImagePickerType) {
    XXImagePickerTypeDefault,   //默认
    XXImagePickerTypePrev,      //预览
    XXImagePickerTypeCrop       //裁剪
};

NS_ASSUME_NONNULL_BEGIN

/**
 图片选择配置模型
 */
@interface XXImagePickerConfigure : NSObject

// 图片选择类型
@property (nonatomic, assign) XXImagePickerType pickerType;

// 是否允许选择视频，默认为YES
@property (nonatomic, assign) BOOL isAllowVideo;
// 是否允许选择图片，默认为YES
@property (nonatomic, assign) BOOL isAllowImage;
// 根据创建时间升序排列，默认为NO
@property (nonatomic, assign) BOOL ascending;

// 相片最小宽度（小于该宽度，不会展示在选择列表中），默认为0.f
@property (nonatomic, assign) BOOL minWidth;
// 相片最小高度(小于该高度，不会展示在选择列表中)，默认为0.f
@property (nonatomic, assign) BOOL minHeight;

// 最大选择个数，默认为9
@property (nonatomic, assign) NSUInteger maxCount;

#pragma mark - UI控制

// 相片间距(默认为5)
@property (nonatomic, assign) CGFloat itemMargin;
// 每行展示个数(默认4个)
@property (nonatomic, assign) NSUInteger columnCount;


#pragma mark - 建议通过[XXImagePickerConfigure defaultConfigure]方法初始化
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

// 默认配置
+ (XXImagePickerConfigure *)defaultConfigure;


@end

NS_ASSUME_NONNULL_END
