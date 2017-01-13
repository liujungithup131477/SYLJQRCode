//
//  UILabel+SYLJAdd.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/11.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "UILabel+SYLJAdd.h"

@implementation UILabel (SYLJAdd)

+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if (label != nil) {
        label.text = text;
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = textColor;
        [label sizeToFit];
    }
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor
                     frame:(CGRect)frame
{
    UILabel *label = [UILabel labelWithText:text fontSize:fontSize textColor:textColor];
    if (label != nil) {
        label.frame = frame;
    }
    return label;
}

@end
