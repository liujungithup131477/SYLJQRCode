//
//  SYLJScanner.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/15.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJScanner.h"
#import <AVFoundation/AVFoundation.h>

/** 最大检测次数 */
#define kMaxDetectedCount 20

@interface SYLJScanner () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, copy) void (^completionCallBack)(NSString *stringValue);
@property (nonatomic, weak) UIView *parentView;
/** 拍摄回话 */
@property (nonatomic, strong) AVCaptureSession *session;
// 预览图层
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *previewLayer;
// 绘制图层
@property (nonatomic, weak) CALayer *drawLayer;
// 当前检测计数
@property (nonatomic, assign) NSInteger currentDetectedCount;
/** 扫描范围 */
@property (nonatomic,assign) CGRect scanFrame;

@end

@implementation SYLJScanner

+ (instancetype)scanQRCodeWithScanView:(UIView *)scanView scanRect:(CGRect)scanRect completion:(void (^)(NSString *stringValue))completion
{
    NSAssert(completion != nil, @"必须传入完成回调");
    
    return [[self alloc] initWithScanView:scanView scanRect:scanRect completion:completion];
}

- (instancetype)initWithScanView:(UIView *)scanView scanRect:(CGRect)scanRect
completion:(void (^)(NSString *stringValue))completion
{
    self = [super init];
    if (self != nil) {
        self.completionCallBack = completion;
        self.parentView = scanView;
        self.scanFrame = scanRect;
        
        [self setupSession];
    }
    return self;
}

/**
 设置扫描会话
 */
- (void)setupSession
{
    // 输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:NULL];
    if (videoInput == nil) {
        NSLog(@"创建输入设备失败");
        return;
    }
    
    // 数据输出
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 拍摄会话 - 判断能够添加设备
    self.session = [[AVCaptureSession alloc] init];
    if (![self.session canAddInput:videoInput]) {
        NSLog(@"无法添加输入设备");
        self.session = nil;
        return;
    }
    if (![self.session canAddOutput:dataOutput]) {
        NSLog(@"无法添加输出设备");
        self.session = nil;
        return;
    }
    
    // 添加输入／输出设备
    [self.session addInput:videoInput];
    [self.session addOutput:dataOutput];
    
    // 设置扫描类型
    dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置预览图层会话
    [self setupLayers];
}

/**
 设置绘制图层和预览图层
 */
- (void)setupLayers
{
    if (self.parentView == nil) {
        NSLog(@"父视图不存在");
        return;
    }
    
    if (self.session == nil) {
        NSLog(@"拍摄会话不存在");
        return;
    }
    
    // 绘制图层
    CALayer *drawLayer = [CALayer layer];
    drawLayer.frame = self.parentView.bounds;
    [self.parentView.layer insertSublayer:drawLayer atIndex:0];
    self.drawLayer = drawLayer;
    
    // 预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.parentView.bounds;
    [self.parentView.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
}

- (void)startScan
{
    if ([self.session isRunning]) return;
    
    self.currentDetectedCount = 0;
    [self.session startRunning];
}

- (void)stopScan
{
    if (![self.session isRunning]) return;
    
    [self.session stopRunning];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self clearDrawLayer];
    
    for (id obj in metadataObjects) {
        // 判断检测到的对象类型
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) return;
        
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        // 判断扫描范围
        if (!CGRectContainsRect(self.scanFrame, dataObject.bounds)) continue;
        
        if (self.currentDetectedCount++ < kMaxDetectedCount) {
            // 绘制边角
            [self drawCornersShape:dataObject];
        } else {
            [self stopScan];
            // 完成回调
            if (self.completionCallBack) {
                self.completionCallBack(dataObject.stringValue);
            }
        }
    }
}

/**
 清空绘制图层
 */
- (void)clearDrawLayer
{
    if (self.drawLayer.sublayers.count == 0) {
        return;
    }
    
    [self.drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

/**
 绘制条码形状(给目标描边)
 
 @param dataObject 识别到的数据对象
 */
- (void)drawCornersShape:(AVMetadataMachineReadableCodeObject *)dataObject
{
    if (!dataObject.corners.count) return;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self cornersPath:dataObject.corners];
    
    [self.drawLayer addSublayer:layer];
}

/**
 使用 corners 数组生成绘制路径
 
 @param corners corners 数组
 @return 绘制路径
 */
- (CGPathRef)cornersPath:(NSArray *)corners
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    
    // 移动到第一个点
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
    [path moveToPoint:point];
    // 遍历剩余的点
    while (index < corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    // 关闭路径
    [path closePath];
    
    return path.CGPath;
}

@end
