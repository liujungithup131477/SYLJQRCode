//
//  SYLJScanQRCodeViewController.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 二维码扫描控制器
 */
@interface SYLJScanQRCodeViewController : UIViewController

/**
 实例化扫描控制器
 
 @param completion 完成回调
 @return 扫描控制器
 */
- (instancetype)initWithCompletion:(void (^)(NSString *stringValue))completion;

/**
 实例化扫描控制器

 @param cardName 名片字符串
 @param avatar 头像图片
 @param completion 完成回调
 @return 扫描控制器
 */
- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *stringValue))completion;

@end

