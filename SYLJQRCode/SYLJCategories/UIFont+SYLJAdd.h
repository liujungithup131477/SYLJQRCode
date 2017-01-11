//
//  UIFont+SYLJAdd.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/11.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KFont(size) ([UIFont systemFontOfSize:size])

@interface UIFont (SYLJAdd)

/**
 创建并返回 UIFont 对象

 @param size 字体大小
 @return UIFont 对象
 */
+ (UIFont *)fontWithSize:(CGFloat)size;

@end
