//
//  SYLJQRCodeNavigationController.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 如果扫描二维码需要导航控制器可以使用此导航控制器
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
