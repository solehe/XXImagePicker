//
//  XXImageMacro.h
//  XXImageDemo
//
//  Created by solehe on 2020/3/28.
//  Copyright © 2020 solehe. All rights reserved.
//

#ifndef XXImageMacro_h
#define XXImageMacro_h

// 获取屏幕的宽度、高度、分辨率
#define SCREEN_BOUNDS           ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH            (SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT           (SCREEN_BOUNDS.size.height)
#define SCREEN_SCALE            [[UIScreen mainScreen] scale]

//顶部安全区域高度
#define SAFEAREA_TOP_HEIGHT     ((SCREEN_HEIGHT == 812.0 || SCREEN_HEIGHT == 896.0) ? 44 : 20)
// 底部安全区域高度
#define SAFEAREA_BOTTOM_HEIGHT  ((SCREEN_HEIGHT == 812.0 || SCREEN_HEIGHT == 896.0) ? 34 : 0)

// 获得控件屏幕的x坐标
#define X(v)                    (v).frame.origin.x
// 获得控件屏幕的y坐标
#define Y(v)                    (v).frame.origin.y
// 获得控件屏幕的宽度
#define W(v)                    (v).frame.size.width
// 获得控件屏幕的高度
#define H(v)                    (v).frame.size.height
// 获得控件屏幕的x坐标
#define MinX(v)                 CGRectGetMinX((v).frame)
// 获得控件屏幕的Y坐标
#define MinY(v)                 CGRectGetMinY((v).frame)
// 横坐标加上到控件中点坐标
#define MidX(v)                 CGRectGetMidX((v).frame)
// 纵坐标加上到控件中点坐标
#define MidY(v)                 CGRectGetMidY((v).frame)
// 横坐标加上控件的宽度
#define MaxX(v)                 CGRectGetMaxX((v).frame)
// 纵坐标加上控件的高度
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// RGB颜色转换
#define RGB(r,g,b)              RGBA(r,g,b,1.0f)
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define RGB16(rgbValue)         [UIColor colorWithRed: \
                                ((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 顶部状态栏高度
#define kNAVIBAR_HEIGHT   (SAFEAREA_TOP_HEIGHT+44.f)

// 底部工具栏高度
#define kTABBAR_HEIGHT    (SAFEAREA_BOTTOM_HEIGHT+60.f)

#endif /* XXImageMacro_h */
