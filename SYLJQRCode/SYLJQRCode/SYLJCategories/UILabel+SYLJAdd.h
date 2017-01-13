//
//  UILabel+SYLJAdd.h
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/11.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SYLJAdd)

#pragma mark - Create font

/**
 创建并返回 UILabel 对象

 @param text 文本内容
 @param fontSize 字体大小
 @param textColor 文字颜色
 @return UILabel 对象
 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor;

/**
 创建并返回 UILabel 对象

 @param text 文本内容
 @param fontSize 字体大小
 @param textColor 文字颜色
 @param frame frame
 @return UILabel 对象
 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor
                     frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
