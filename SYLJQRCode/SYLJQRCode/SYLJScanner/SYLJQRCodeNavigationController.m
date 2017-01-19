//
//  SYLJQRCodeNavigationController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/13.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJQRCodeNavigationController.h"
#import "SYLJScanQRCodeViewController.h"

@interface SYLJQRCodeNavigationController ()

@property (nonatomic, weak) SYLJScanQRCodeViewController *scannerVc;

@end

@implementation SYLJQRCodeNavigationController

+ (instancetype)scannerWithCompletion:(void (^)(NSString *))completion
{
    NSAssert(completion, @"必须传入完成回调");
    
    return [[self alloc] initWithCompletion:completion];
}

- (instancetype)initWithCompletion:(void (^)(NSString *))completion
{
    if (self = [super init]) {
        SYLJScanQRCodeViewController *scannerVc = [[SYLJScanQRCodeViewController alloc] initWithCompletion:completion];
        self.scannerVc = scannerVc;
        
        [self setTitle:@"扫一扫"
            titleColor:[UIColor whiteColor]
          barTintColor:[UIColor redColor]];
        
        [self pushViewController:scannerVc animated:NO];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor barTintColor:(UIColor *)barTintColor;
{
    if (titleColor == nil) {
        titleColor = [UIColor whiteColor];
    }
    if (barTintColor == nil) {
        barTintColor = [UIColor redColor];
    }
    
    self.navigationBar.barTintColor = barTintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};
}

- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor barTintColor:(UIColor *)barTintColor
{
    if (title == nil) {
        title = @"扫一扫";
    }
    
    self.scannerVc.title = title;
    [self setTitleColor:titleColor barTintColor:barTintColor];
}

- (void)setTitle:(NSString *)title
{
    self.scannerVc.title = title;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
