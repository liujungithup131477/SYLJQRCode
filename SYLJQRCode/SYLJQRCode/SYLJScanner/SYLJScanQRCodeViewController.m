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
#import "SYLJGenerateQRCodeViewController.h"

/// 控件间距
#define kControlMargin  32.0
/// 相册图片最大尺寸
#define kImageMaxSize   CGSizeMake(1000, 1000)

@interface SYLJScanQRCodeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void (^completionCallBack)(NSString *stringValue);
@property (nonatomic, weak) SYLJScannerBorderView *scannerBorderView;
@property (nonatomic, strong) SYLJScanner *scanner;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) UIImage *avatar;

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

- (instancetype)initWithCardName:(NSString *)cardName avatar:(UIImage *)avatar completion:(void (^)(NSString *))completion {
    self = [super init];
    if (self) {
        self.cardName = cardName;
        self.avatar = avatar;
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
    [self setupPostcard];
}

- (void)setupNavigationController
{
    [self prepareNavigationBar];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor greenColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickAlbumButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
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
    self.tipLabel = tipLabel;
}

- (void)setupScannerMaskView
{
    SYLJScannerMaskView *maskView = [SYLJScannerMaskView maskViewWithFrame:self.view.bounds cropRect:self.scannerBorderView.frame];
    [self.view insertSubview:maskView atIndex:0];
}

- (void)setupPostcard
{
    UIButton *cardBtn = [[UIButton alloc] init];
    [cardBtn setTitle:@"我的名片" forState:UIControlStateNormal];
    [cardBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [cardBtn sizeToFit];
    cardBtn.center = CGPointMake(self.tipLabel.center.x, CGRectGetMaxY(self.tipLabel.frame) + kControlMargin);
    [cardBtn addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cardBtn];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)clickCardButton
{
    SYLJGenerateQRCodeViewController *generateQRCode = [[SYLJGenerateQRCodeViewController alloc] initWithCardName:self.cardName avatar:self.avatar];
    
    [self showViewController:generateQRCode sender:nil];
}

/// 点击相册按钮
- (void)clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"无法访问相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    
    [self showDetailViewController:picker sender:nil];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [self resizeImage:info[UIImagePickerControllerOriginalImage]];
    
    [SYLJScanner scanImage:image completion:^(NSArray *values) {
        if (values.count > 0) {
            self.completionCallBack([values firstObject]);
            [self dismissViewControllerAnimated:YES completion:^{
                [self closeBtnClick];
            }];
        } else {
            self.tipLabel.text = @"没有识别到二维码，请选择其他照片";
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image {
    
    if (image.size.width < kImageMaxSize.width && image.size.height < kImageMaxSize.height) {
        return image;
    }
    
    CGFloat xScale = kImageMaxSize.width / image.size.width;
    CGFloat yScale = kImageMaxSize.height / image.size.height;
    CGFloat scale = MIN(xScale, yScale);
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}


@end
