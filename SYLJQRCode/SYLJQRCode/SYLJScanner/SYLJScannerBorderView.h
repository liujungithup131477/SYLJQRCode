//
//  SYLJScannerBorderView.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#define KScannerWidth 250 //扫描背景框宽度

#import <UIKit/UIKit.h>

/**
 设置二维码扫描的边框
 */
@interface SYLJScannerBorderView : UIView

/**
 开始扫描
 */
- (void)startScannerAnimating;

/**
 停止扫描
 */
- (void)stopScannerAnimating;

@end
