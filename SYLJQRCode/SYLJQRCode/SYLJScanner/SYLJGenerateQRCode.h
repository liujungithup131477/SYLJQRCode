//
//  SYLJGenerateQRCode.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/20.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 二维码图像生成器
 用 string / 头像 异步生成二维码图像
 */

@interface SYLJGenerateQRCode : NSObject

/**
 使用 string / 头像 异步生成二维码图像

 @param string 二维码图像的字符串
 @param avatar 头像图像，默认比例 0.2
 @param completion 完成回调
 */
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar completion:(void (^)(UIImage *))completion;

/**
 使用 string / 头像 异步生成二维码图像，并且指定头像占二维码图像的比例

 @param string 二维码图像的字符串
 @param avatar 头像图像
 @param scale 头像占二维码图像的比例
 @param completion 完成回调
 */
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion;

@end
