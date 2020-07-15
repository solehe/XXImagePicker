//
//  XXProgressView.m
//  XXImageDemo
//
//  Created by solehe on 2020/3/29.
//  Copyright © 2020 solehe. All rights reserved.
//

#import "XXImageMacro.h"
#import "XXProgressView.h"

@implementation XXProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    // 更新UI
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.f);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, 115.0/255.0, 115.0/255.0, 115.0/255.0, 0.2f);
    
    //绘制环形进度条底框
    CGContextAddArc(context, self.center.x, self.center.y, 20, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //文本风格，设置居中
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    //绘制文字
    NSDictionary *attri = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
                            NSForegroundColorAttributeName : [UIColor whiteColor],
                            NSParagraphStyleAttributeName : paragraphStyle};
    NSString *prcent = [NSString stringWithFormat:@"%zd%%", (NSUInteger)(self.progress*100)];
    [prcent drawInRect:CGRectMake(0, rect.size.height/2-5.f, rect.size.width, 10) withAttributes:attri];
    
    //绘制环形进度环
    CGFloat to = MAX(self.progress, 0.0318) * M_PI * 2 - M_PI/2; // 改变初始位置
    
    CGContextSetLineWidth(context, 4.f);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    
    //绘制环形进度条底框
    CGContextAddArc(context, self.center.x, self.center.y, 20, -M_PI/2, to, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
