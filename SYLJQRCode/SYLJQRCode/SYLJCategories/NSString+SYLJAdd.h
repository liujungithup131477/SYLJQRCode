//
//  NSString+SYLJAdd.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/14.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 处理带有@2x，@3x的切图名称和路径
 */
@interface NSString (SYLJAdd)

/**
 给切图的名称增加@2x,@3x等字符串

 @param scale scale
 @return 拼接好的字符串
 */
- (NSString *)stringByAppendingNameScale:(CGFloat)scale;

/**
 给切图的路径增加@2x,@3x等字符串

 @param scale scale
 @return 拼接好的字符串
 */
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;

@end
