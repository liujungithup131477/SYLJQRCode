//
//  SYLJQRCodeNavigationController.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 二维码导航控制器
 
 作用:
 
 * 提供一个导航控制器，扫描 `二维码 / 条形码`
 * 能够生成指定 `字符串` + `avatar(可选)` 的二维码名片
 * 能够识别相册图片中的二维码(iOS 64 位设备)
 
 使用:
 
 @code
 NSString *cardName = @"一天一天";
 UIImage *avatar = [UIImage imageNamed:@"avatar"];
 
 // 实例化控制器，并指定完成回调
 SYLJQRCodeNavigationController *scanQRNaV = [SYLJQRCodeNavigationController scannerWithCompletion:^(NSString * _Nonnull stringValue) {
 NSLog(@"扫描结果(URL): %@", stringValue);
 self.label.text = stringValue;
 }];
 
 // 展现扫描控制器
 [self showDetailViewController:scanner sender:nil];
 }];
 
 @endcode
 */
@interface SYLJQRCodeNavigationController : UINavigationController

/**
 使用 `名片字符串` 实例化扫描导航控制器（适合访问照片库中的二维码）
 
 @param cardName 名片字符串
 @param avatar 头像图像
 @param completion 完成回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *stringValue))completion;

/**
 实例化扫描导航控制器 (此方式只适用于二维码扫描，不适合访问照片库中的二维码)
 
 @param completion 完成回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithCompletion:(void (^)(NSString *stringValue))completion;

/**
 设置导航栏标题颜色和主题色
 
 @param titleColor 标题颜色(默认是白色)
 @param barTintColor 主题色(默认是红色)
 */
- (void)setTitleColor:(UIColor *)titleColor barTintColor:(UIColor *)barTintColor;

/**
 设置导航栏标题、标题颜色和主题色
 
 @param title 导航栏标题(默认是扫一扫)
 @param titleColor 标题颜色(默认是白色)
 @param barTintColor 主题色(默认是红色)
 */
- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor barTintColor:(UIColor *)barTintColor;

@end
