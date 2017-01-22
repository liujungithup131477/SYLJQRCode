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
@property (nonatomic, weak) UIView *scanView;
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

#pragma mark - 
#pragma mark - 扫描二维码
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
        self.scanView = scanView;
        self.scanFrame = scanRect;
        
        [self setupSession];
    }
    return self;
}

#pragma mark - Setup scanner
/**
 设置扫描会话
 */
- (void)setupSession
{
    // 输入设备
    //AVCaptureDevice表示提供实时输入媒体数据（例如视频和音频）的物理设备。
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //AVCaptureDeviceInput是AVCaptureInput的一个具体子类，它提供了一个从AVCaptureDevice捕获媒体的接口。
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:NULL];
    if (videoInput == nil) {
        NSLog(@"创建输入设备失败");
        return;
    }
    
    // 数据输出
    //AVCaptureOutput是一个抽象类，定义了AVCaptureSession的输出目标的接口。
    //AVCaptureMetadataOutput是AVCaptureOutput的一个具体子类，可用于处理来自附加连接的元数据对象。
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 拍摄会话 - 判断能够添加设备
    //AVCaptureSession是AVFoundation捕获类的中心枢纽。
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
    //metadataObjectTypes:指定接收方应向客户端呈现的元数据对象的类型。
    //availableMetadataObjectTypes:表示接收器支持的元数据对象类型。
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
    if (self.scanView == nil) {
        NSLog(@"扫描视图不存在");
        return;
    }
    
    if (self.session == nil) {
        NSLog(@"拍摄会话不存在");
        return;
    }
    
    // 绘制图层
    CALayer *drawLayer = [CALayer layer];
    drawLayer.frame = self.scanView.bounds;
    [self.scanView.layer insertSublayer:drawLayer atIndex:0];
    self.drawLayer = drawLayer;
    
    // 预览图层
    //CoreAnimation层子类，用于预览AVCaptureSession的视觉输出。
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //定义视频在AVCaptureVideoPreviewLayer中如何显示的字符串。
    //AVLayerVideoGravityResizeAspectFill:保持宽高比; 填充层边界。
    //在设置AVPlayerLayer或AVCaptureVideoPreviewLayer实例的videoGravity属性时，可以使用AVLayerVideoGravityResizeAspectFill。
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.scanView.bounds;
    [self.scanView.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
}

#pragma mark - Public methods
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

#pragma mark - Pravite methods
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
    //从`dict'的内容创建一个CGPoint（可能返回早先存储在'CGPointCreateDictionaryRepresentation'中的值）并存储的值“点”。 成功返回true; 否则为假。
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

#pragma mark - 
#pragma mark - 扫描图片
+ (void)scanImage:(UIImage *)image completion:(void (^)(NSArray *values))completion
{
    /*
     一种识别静态图像或视频中的显着特征（例如面部和条形码）的图像处理器。
     CIDetector对象使用图像处理来搜索和识别静止图像或视频中的显着特征（面部，矩形和条形码）。 检测到的功能由提供有关每个功能的详细信息的CIFeature对象表示。
     这个类可以维护许多可能影响性能的状态变量。 因此为了获得最佳性能，重用CIDetector实例而不是创建新的实例。
     */
    /*
     创建并返回已配置的检测器。
     CIDetector对象可以潜在地创建和保存大量的资源。 在可能的情况下，重用相同的CIDetector实例。 此外，当使用检测器对象处理图像时，如果用于初始化检测器的CIContext与用于处理CIImage对象的上下文相同，则应用程序的性能会更好。
     参数
     type(类型)
     表示您感兴趣的检测器种类的字符串。请参见检测器类型。
     CIDetectorTypeQRCode:
     检测器，用于在静止图像或视频中搜索快速响应代码（2D条形码类型），返回提供有关检测到的条形码信息的CIQRCodeFeature对象。
     context(上下文)
     检测器在分析图像时可以使用的Core Image上下文。
     options(选项)
     包含有关如何配置检测器的详细信息的字典。 请参阅检测器配置键。
     CIDetectorAccuracy (key): 用于指定检测器所需精度的值选项。
     CIDetectorAccuracyLow (value): 表示检测器应选择精度较低但可以更快处理的技术。
     CIDetectorAccuracyHigh (value): 表示检测器应选择精度较高的技术，即使它需要更多的处理时间。
     返回
     配置的探测器。
     */
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    CIImage *ciimage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:ciimage];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:features.count];
    for (CIQRCodeFeature *qrFeature in features) {
        [tempArray addObject:qrFeature.messageString];
    }
    
    if (completion) {
        completion(tempArray.copy);
    }
}

@end
