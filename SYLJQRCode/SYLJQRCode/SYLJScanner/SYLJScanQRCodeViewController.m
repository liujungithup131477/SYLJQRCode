//
//  SYLJScanQRCodeViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScanQRCodeViewController.h"
#import "SYLJScannerBorderView.h"
#import "NSBundle+SYLJAdd.h"
#import "SYLJMacro.h"

#define KScannerWidth 280

@interface SYLJScanQRCodeViewController ()

@property (nonatomic, weak) UIView *scannerBorderView;

@end

@implementation SYLJScanQRCodeViewController

#pragma mark -
#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupNavigationController];
    [self setupUI];
}

- (void)setupUI
{
    [self setupScannerBorderView];
    [self setupTipLabel];
}

- (void)setupNavigationController
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
}

- (void)setupScannerBorderView
{
    CGFloat scannerBorderViewX = (kScreenWidth - KScannerWidth) * 0.5;
    CGFloat scannerBorderViewY = (kScreenHeight - KScannerWidth) * 0.5;
    CGFloat scannerBorderViewW = KScannerWidth;
    CGFloat scannerBorderViewH = KScannerWidth;
    SYLJScannerBorderView *scannerBorderView = [[SYLJScannerBorderView alloc] initWithFrame:CGRectMake(scannerBorderViewX, scannerBorderViewY, scannerBorderViewW, scannerBorderViewH)];
    [self.view addSubview:scannerBorderView];
    self.scannerBorderView = scannerBorderView;
}

- (void)setupTipLabel
{
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.scannerBorderView.frame) + 10, kScreenWidth, [UIFont systemFontOfSize:18].lineHeight);
    
    [self.view addSubview:tipLabel];
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
