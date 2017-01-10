//
//  SYLJScanQRCodeViewController.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/10.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SYLJMacro.h"

@interface SYLJScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

/**
 Capture:捕获
 //捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
 */
@property (nonatomic, strong) AVCaptureDevice *device;

/**
 AVCaptureDeviceInput 代表输入设备，他使用 AVCaptureDevice 来初始化
 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;

/**
 Metadata:元数据
 //设置输出类型为 Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
 //当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/**
 session:由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
 */
@property (nonatomic, strong) AVCaptureSession *session;

/**
 图像预览层，实时显示捕获的图像
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation SYLJScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatCaptureDevice
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:NULL];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，一旦扫描到指定类型的数据，就会通过代理输出
    //在扫描的过程中，会分析扫描的内容，分析成功后就会调用代理方法在队列中输出
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定当扫描到二维码的时候，产生输出
    //AVMetadataObjectTypeQRCode 指定二维码
    //指定识别类型一定要放到添加到session之后
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //设置扫描信息的识别区域，左上角为(0,0),右下角为(1,1),不设的话全屏都可以识别。设置过之后可以缩小信息扫描面积加快识别速度。
    //这个属性并不好设置，整了半天也没太搞明白，到底x,y,width,height,怎么是对应的，这是我一点一点试的扫描区域，看不到只能调一下，扫一扫试试
    [self.output setRectOfInterest:CGRectMake(0.1 ,0.3 , 0.4, 0.4)];
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
}

@end