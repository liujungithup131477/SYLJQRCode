//
//  SYLJScanner.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/15.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 二维码/条码扫描器
 */
@interface SYLJScanner : NSObject

/**
 使用视图实例化扫描器，扫描预览窗口会添加到指定视图中
 
 @param scanView 指定的视图
 @param scanRect 扫描范围
 @param completion 完成回调
 @return 扫描器
 */
+ (instancetype)scanQRCodeWithScanView:(UIView *)scanView scanRect:(CGRect)scanRect completion:(void (^)(NSString *stringValue))completion;

/**
 开始扫描
 */
- (void)startScan;

/**
 停止扫描
 */
- (void)stopScan;

/// 扫描图像
///
/// @param image 包含二维码的图像
/// @remark 目前只支持 64 位的 iOS 设备
+ (void)scanImage:(UIImage *)image completion:(void (^)(NSArray *values))completion;

@end
