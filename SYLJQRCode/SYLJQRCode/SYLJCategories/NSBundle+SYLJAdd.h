//
//  NSBundle+SYLJAdd.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/14.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *寻找切图文件路径
 *包括以下格式的 name:"/","@1x","@2x","@3x"
 */
@interface NSBundle (SYLJAdd)


/**
 获取沙盒的根目录下的切图

 @param name 切图名称
 @param ext ext （例如：@2）
 @param bundlePath [[[NSBundle mainBundle] bundlePath]
 @return 切图路径
 */
+ (nullable NSString *)pathForScaledResource:(nullable NSString *)name ofType:(nullable NSString *)ext inDirectory:(nullable NSString *)bundlePath;

/**
 获取沙盒的根目录下的切图
 
 @param name 切图名称
 @param ext ext （例如：@2）
 @param subpath bundle下的目标目录
 @return 切图路径
 */
- (nullable NSString *)pathForScaledResource:(nullable NSString *)name ofType:(nullable NSString *)ext inDirectory:(nullable NSString *)subpath;

@end

NS_ASSUME_NONNULL_END
