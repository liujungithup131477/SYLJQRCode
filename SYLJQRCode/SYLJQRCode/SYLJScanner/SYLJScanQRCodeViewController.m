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
#import "SYLJScanner.h"
#import "SYLJScannerMaskView.h"

/// 控件间距
#define kControlMargin  32.0

@interface SYLJScanQRCodeViewController ()

@property (nonatomic, copy) void (^completionCallBack)(NSString *stringValue);
@property (nonatomic, weak) SYLJScannerBorderView *scannerBorderView;
@property (nonatomic, strong) SYLJScanner *scanner;

@end

@implementation SYLJScanQRCodeViewController

#pragma mark -
#pragma mark - Life cycle methods
- (instancetype)initWithCompletion:(void (^)(NSString *stringValue))completion
{
    self = [super init];
    if (self != nil) {
        self.completionCallBack = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationController];
    [self setupUI];
    [self setupScanner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scannerBorderView startScannerAnimating];
    [self.scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.scannerBorderView stopScannerAnimating];
    [self.scanner stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - Pravite methods (setup View)
- (void)setupUI
{
    [self setupScannerBorderView];
    [self setupScannerMaskView];
    [self setupTipLabel];
}

- (void)setupNavigationController
{
    [self prepareNavigationBar];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor greenColor];
}

- (void)prepareNavigationBar
{
    CGSize size = self.navigationController.navigationBar.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextAddRect(context, CGRectMake(0, 0, size.width, 1));  //向上下文的路径添加单个rect。
    CGContextDrawPath(context, kCGPathFill); //使用绘图模式`mode'绘制上下文的路径。
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.navigationController.navigationBar.shadowImage = image;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.width+20), NO, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9] setFill];
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height+20));
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);
    UIImage *simage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:simage forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
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
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(self.scannerBorderView.center.x, CGRectGetMaxY(self.scannerBorderView.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
}

- (void)setupScannerMaskView
{
    SYLJScannerMaskView *maskView = [SYLJScannerMaskView maskViewWithFrame:self.view.bounds cropRect:self.scannerBorderView.frame];
    [self.view insertSubview:maskView atIndex:0];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/** 创建扫描器 */
- (void)setupScanner
{
    __weak typeof(self) weakSelf = self;
    self.scanner = [SYLJScanner scanQRCodeWithScanView:self.view scanRect:self.scannerBorderView.frame completion:^(NSString *stringValue) {
        // 完成回调
        weakSelf.completionCallBack(stringValue);
        NSLog(@"%@",stringValue);
        // 关闭
        [weakSelf closeBtnClick];
    }];
}

@end
