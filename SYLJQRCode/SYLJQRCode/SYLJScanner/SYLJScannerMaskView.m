//
//  SYLJScannerMaskView.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/17.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScannerMaskView.h"

@interface SYLJScannerMaskView ()

@property (nonatomic, assign) CGRect cropRect;

@end

@implementation SYLJScannerMaskView

+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect
{
    SYLJScannerMaskView *maskView = [[SYLJScannerMaskView alloc] initWithFrame:frame];
    if (maskView != nil) {
        maskView.backgroundColor = [UIColor clearColor];
        maskView.cropRect = cropRect;
    }
    return maskView;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0.0 alpha:0.4] setFill];
    CGContextFillRect(ctr, rect);

    CGContextClearRect(ctr, _cropRect);
    
    [[UIColor colorWithWhite:0.95 alpha:1] setStroke];
    CGContextStrokeRectWithWidth(ctr, CGRectInset(_cropRect, 1, 1), 1);
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    
    [self setNeedsDisplay];
}

@end
