//
//  SYLJQRCodeNavigationController.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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
 实例化扫描导航控制器
 
 @param completion 完成回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithCompletion:(void (^)(NSString *stringValue))completion;

/**
 设置导航栏标题颜色和主题色
 
 @param titleColor 标题颜色(默认是白色)
 @param barTintColor 主题色(默认是红色)
 */
- (void)setTitleColor:(nullable UIColor *)titleColor barTintColor:(nullable UIColor *)barTintColor;

/**
 设置导航栏标题、标题颜色和主题色
 
 @param title 导航栏标题(默认是扫一扫)
 @param titleColor 标题颜色(默认是白色)
 @param barTintColor 主题色(默认是红色)
 */
- (void)setTitle:(nullable NSString *)title titleColor:(nullable UIColor *)titleColor barTintColor:(nullable UIColor *)barTintColor;

@end

NS_ASSUME_NONNULL_END
