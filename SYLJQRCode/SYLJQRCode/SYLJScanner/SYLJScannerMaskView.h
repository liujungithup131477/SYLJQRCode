//
//  SYLJScannerMaskView.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/17.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 扫描遮罩视图
 */
@interface SYLJScannerMaskView : UIView

/**
 使用裁切区域实例化遮罩视图
 
 @param frame 视图区域
 @param cropRect 裁切区域
 @return 遮罩视图
 */
+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect;

@end

NS_ASSUME_NONNULL_END
