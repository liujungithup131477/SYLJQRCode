//
//  SYLJScanQRCodeViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScanQRCodeViewController.h"
#import "SYLJScannerBorderView.h"
#import "NSString+SYLJAdd.h"
#import "NSBundle+SYLJAdd.h"

@interface SYLJScanQRCodeViewController ()

@end

@implementation SYLJScanQRCodeViewController

#pragma mark -
#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationController];
    [self setupUI];
}

- (void)setupUI
{
    SYLJScannerBorderView *scannerBorderView = [[SYLJScannerBorderView alloc] init];
    scannerBorderView.frame = CGRectMake(100, 200, 100, 100);
    [self.view addSubview:scannerBorderView];
    
    NSString *str = @"juxingjiaoleftup.png";
    NSString *nStr = [str stringByAppendingPathScale:2];
    
    NSString *b = [[NSBundle mainBundle] pathForScaledResource:@"juxingjiaoleftup" ofType:@"png" inDirectory:@"SYLJQRCode.bundle"];
    NSLog(@"--------------%@",b);
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SYLJQRCode.bundle"];
    NSString *c = [NSBundle pathForScaledResource:@"juxingjiaoleftup" ofType:@"png" inDirectory: bundlePath];
    NSLog(@"##############%@",c);
    
    NSLog(@"wangxiaochen----%@",nStr);
}

- (void)setupNavigationController
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
