//
//  SYLJScannerBorderView.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScannerBorderView.h"
#import "NSBundle+SYLJAdd.h"

@interface SYLJScannerBorderView ()

@property (nonatomic, strong) UIImageView *scannerLine;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation SYLJScannerBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.clipsToBounds = YES;
    //    [self setupBgView];
    [self setupScannerLine];
    [self setupCornerView];
}

#pragma mark - 
#pragma mark - Public methods
- (void)startScannerAnimating
{
    [self stopScannerAnimating];
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
    } completion:NULL];
}

- (void)stopScannerAnimating
{
    [self.scannerLine.layer removeAllAnimations];
    
    self.scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, 0);
}

#pragma mark - 
#pragma mark - Setter
- (UIImageView *)scannerLine
{
    if (_scannerLine == nil) {
        _scannerLine = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForScaledResource:@"qr_code_line@2x" ofType:@"png" inDirectory:@"SYLJQRCode.bundle"];
        _scannerLine.image = [UIImage imageWithContentsOfFile:path];
        [_scannerLine sizeToFit];
    }
    return _scannerLine;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForScaledResource:@"qr_pick_bg@2x" ofType:@"png" inDirectory:@"SYLJQRCode.bundle"];
        _bgView.image = [UIImage imageWithContentsOfFile:path];
        [_bgView sizeToFit];
    }
    return _bgView;
}

#pragma mark - 
#pragma mark - Pravite methods (setup View)
- (void)setupBgView
{
    [self addSubview:self.bgView];
    self.bgView.frame = CGRectMake(0, 0, KScannerWidth, KScannerWidth);
}

- (void)setupScannerLine
{
    [self addSubview:self.scannerLine];
    CGFloat scannerLineX = (self.bounds.size.width - self.scannerLine.bounds.size.width) * 0.5;
    CGFloat scannerLineY = 0;
    CGFloat scannerLineW = self.scannerLine.bounds.size.width;
    CGFloat scannerLineH = self.scannerLine.bounds.size.height;
    self.scannerLine.frame = CGRectMake(scannerLineX, scannerLineY, scannerLineW, scannerLineH);
}

- (void)setupCornerView
{
    for (int i = 0; i < 4; i++) {
        UIImageView *cornerView = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"cornerView%i",i];
        NSString *path = [[NSBundle mainBundle] pathForScaledResource:imageName ofType:@"png" inDirectory:@"SYLJQRCode.bundle"];
        cornerView.image = [UIImage imageWithContentsOfFile:path];
        [cornerView sizeToFit];
        [self addSubview:cornerView];
        CGFloat offsetX = self.bounds.size.width - cornerView.bounds.size.width;
        CGFloat offsetY = self.bounds.size.height - cornerView.bounds.size.height;
        switch (i) {
            case 0:
                break;
            case 1:
                cornerView.frame = CGRectOffset(cornerView.frame, offsetX, 0);
                break;
            case 2:
                cornerView.frame = CGRectOffset(cornerView.frame, 0, offsetY);
                break;
            case 3:
                cornerView.frame = CGRectOffset(cornerView.frame, offsetX, offsetY);
                break;
            default:
                break;
        }
    }
}

@end
