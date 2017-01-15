//
//  SYLJScannerBorderView.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScannerBorderView.h"
#import "UIImage+YYAdd.h"

@interface SYLJScannerBorderView ()

@property (nonatomic, strong) UIImageView *scannerLine;

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
    
}

#pragma mark - 
#pragma mark - setter
- (UIImageView *)scannerLine
{
    if (_scannerLine == nil) {
        _scannerLine = [[UIImageView alloc] init];
//        _scannerLine.image = [UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>];
//        NSString *path = [[NSBundle mainBundle] pathForResource:<#(nullable NSString *)#> ofType:<#(nullable NSString *)#> inDirectory:<#(nullable NSString *)#>];
    }
    return _scannerLine;
}

#pragma mark - 
#pragma mark - Pravite methods


@end
