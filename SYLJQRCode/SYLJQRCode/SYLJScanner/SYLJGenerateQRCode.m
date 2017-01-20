//
//  SYLJGenerateQRCode.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/20.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "SYLJGenerateQRCode.h"

@implementation SYLJGenerateQRCode

#pragma mark - 生成二维码
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar completion:(void (^)(UIImage *))completion {
    [self qrImageWithString:string avatar:avatar scale:0.20 completion:completion];
}

+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
    
    NSAssert(completion != nil, @"必须传入完成回调");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        /*CIFilter是Core Image的过滤器对象，它使用其属性封装过滤器
         图像处理器，其通过操纵一个或多个输入图像或通过生成新的图像数据来产生图像。
         CIFilter类生成一个CIImage对象作为输出。 通常，过滤器采用一个或多个图像作为输入。 然而，一些滤波器基于其他类型的输入参数生成图像。 通过使用键值对来设置和检索CIFilter对象的参数。
         您可以将CIFilter对象与其他Core Image类（例如CIImage，CIContext和CIColor）结合使用，以便在处理图像，创建过滤器生成器或编写自定义过滤器时利用内置的Core Image过滤器。
         CIFilter对象是可变的，因此不能在线程之间安全共享。 每个线程必须创建自己的CIFilter对象，但您可以在线程之间传递一个过滤器的不可变输入和输出CIImage对象。
         
         要快速了解如何设置和使用Core Image过滤器，请参阅Core Image Programming Guide。
         */
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        //将所有输入设置为其默认值（其中默认值已定义，其他输入保持原样）。
        [qrFilter setDefaults];
        [qrFilter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
        
        /*
         由Core Image过滤器处理或生成的图像的表示。
         您可以将CIImage对象与其他Core Image类（例如CIFilter，CIContext，CIVector和CIColor）结合使用，以在处理图像时利用内置的Core Image过滤器。 您可以使用从各种来源提供的数据创建CIImage对象，包括Quartz 2D图像，Core视频图像缓冲区（CVImageBufferRef），基于URL的对象和NSData对象。
         虽然CIImage对象具有与其关联的图像数据，但它不是图像。 您可以将CIImage对象视为图像“配方”.CIImage对象具有生成映像所需的所有信息，但Core Image实际上不会渲染图像，直到它被告知这样做。 这种“延迟评估”方法允许Core Image尽可能高效地运行。
         CIContext和CIImage对象是不可变的，这意味着每个线程可以安全地共享。 多线程可以使用相同的GPU或CPU CIContext对象来渲染CIImage对象。 但是，这不是CIFilter对象的情况，这是可变的。 CIFilter对象不能在线程之间安全共享。 如果你的应用程序是多线程的，每个线程必须创建自己的CIFilter对象。 否则，您的应用可能会出现意外。
         Core Image还提供自动调整方法。 这些方法分析图像的常见缺陷，并返回一组过滤器以纠正这些缺陷。 滤波器预设有用于通过改变皮肤色调，饱和度，对比度和阴影的值以及用于消除由闪光引起的红眼或其它伪像来改善图像质量的值。 （请参阅获取自动调整过滤器。）
         有关可以用来在iOS和macOS上创建CIImage对象的所有方法的讨论，请参阅Core Image Programming Guide。
         */
        CIImage *ciImage = qrFilter.outputImage;
        
        /*
         返回根据您提供的缩放值构建的仿射变换矩阵。
         此函数创建一个CGAffineTransform结构，您可以使用（并重复使用，如果需要）缩放坐标系统。 
         矩阵采用以下形式：
         因为第三列总是（0,0,1），所以此函数返回的CGAffineTransform数据结构仅包含前两列的值。
         这些是用于缩放点（x，y）的坐标的结果方程：
         如果只想缩放要绘制的对象，则无需构建仿射变换来进行绘制。 缩放绘图的最直接的方法是调用CGContextScaleCTM函数。
         sx
         缩放坐标系x轴的因子。
         sy
         缩放坐标系y轴的因子。
         */
        /*
         void CGContextScaleCTM(CGContextRef cg_nullable c,
         CGFloat sx, CGFloat sy)
         更改上下文中用户坐标系的比例。
         c
         图形上下文。
         sx
         缩放指定上下文的坐标空间的x轴的因子。
         sy
         缩放指定上下文的坐标空间的y轴的因子。
         */
        CGAffineTransform transform = CGAffineTransformMakeScale(10, 10);
        /* 在应用仿射变换后，返回表示原始图像的新图像。 */
        CIImage *transformedImage = [ciImage imageByApplyingTransform:transform];
        /*
         用于渲染图像处理结果并执行图像分析的评估上下文。
         CIContext类提供了使用Quartz 2D，Metal或OpenGL的Core Image处理的评估上下文。 您可以使用CIContext对象与其他Core Image类（例如CIFilter，CIImage和CIColor）结合使用Core Image过滤器处理图像。 您还可以使用带有CIDetector类的Core Image上下文来分析图像 - 例如，检测面或条形码。
         CIContext和CIImage对象是不可变的，因此多个线程可以使用相同的CIContext对象来呈现CIImage对象。 但是，CIFilter对象是可变的，因此不能在线程之间安全共享。 每个线程必须创建自己的CIFilter对象，但您可以在线程之间传递一个过滤器的不可变输入和输出CIImage对象。
         */
        /*
         使用指定的选项初始化没有特定呈现目标的上下文。
         如果创建上下文而未指定渲染目标，Core Image会根据当前设备的功能和选项字典中的设置自动选择并内部管理渲染目标。 对于“Drawing Images像”中列出的方法，不能使用没有明确目标的上下文。 相反，请使用“Rendering Images”中列出的方法。
         选项字典定义上下文的行为，例如颜色空间和呈现质量。 例如，要创建基于CPU的上下文，请使用kCIContextUseSoftwareRenderer键。
         参数
         options(选项)
         包含上下文选项的字典。 有关适用的键和值，请参阅上下文选项。
         返回
         初始化的Core Image上下文。
         */
        CIContext *context = [CIContext contextWithOptions:nil];
        /*
         - (nullable CGImageRef)createCGImage:(CIImage *)image
         fromRect:(CGRect)fromRect
         
         从Core Image图像对象的区域创建Quartz 2D图像。
         使用上下文将图像的区域呈现为临时缓冲区，然后创建并返回具有结果的Quartz 2D图像。
         参数
         im
         Core Image图像对象。
         r
         要呈现的图像的区域。
         返回
         一个Quartz 2D图像。 当您不再需要它时，您负责释放返回的图像。
         */
        CGImageRef cgImage = [context createCGImage:transformedImage fromRect:transformedImage.extent];
        /*
         创建并返回具有指定比例和方向因子的图像对象。
         此方法不缓存图像对象。 您可以使用Core Graphics框架的方法来创建Quartz图像引用。
         参数
         imageRef
         Quartz图像对象。
         scale(规模)
         解释图像数据时使用的比例因子。 指定比例因子1.0将导致图像的大小与图像的基于像素的尺寸匹配。 应用不同的缩放因子会更改由size属性报告的图像大小。
         orientation(方向)
         图像数据的方向。 您可以使用此参数指定应用于图像的任何旋转因子。
         返回
         指定Quartz图像的新图像对象，如果方法无法从指定的图像引用初始化图像，则为nil。
         
         ** UIImageOrientation : 指定图像的可能方向。
         UIImageOrientationUp,            // default orientation
         图像的默认方向。 图像被右侧向上绘制。
         UIImageOrientationDown,          // 180 deg rotation
         图像旋转180度
         UIImageOrientationLeft,          // 90 deg CCW
         图像顺时针旋转90度
         UIImageOrientationRight,         // 90 deg CW
         图像逆时针旋转90度
         UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
         图像绘制为使用UIImageOrientationUp值绘制的图像的镜像版本。 换句话说，图像沿着其水平轴翻转
         UIImageOrientationDownMirrored,  // horizontal flip
         图像绘制为使用UIImageOrientationDown值绘制的图像的镜像版本。 这等效于沿着其水平轴将图像翻转为“向上”取向，然后将图像旋转180度
         UIImageOrientationLeftMirrored,  // vertical flip
         图像绘制为使用UIImageOrientationLeft值绘制的图像的镜像版本。 这相当于沿着其水平轴将图像翻转为“向上”取向，然后将图像逆时针旋转90度
         UIImageOrientationRightMirrored, // vertical flip
         图像绘制为使用UIImageOrientationRight值绘制的图像的镜像版本。 这相当于沿着其水平轴将图像翻转为“向上”取向，然后顺时针旋转图像90度
         */
        UIImage *qrImage = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        
        if (avatar != nil) {
            qrImage = [self qrcodeImage:qrImage addAvatar:avatar scale:scale];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{ completion(qrImage); });
    });
}

+ (UIImage *)qrcodeImage:(UIImage *)qrImage addAvatar:(UIImage *)avatar scale:(CGFloat)scale {
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, qrImage.size.width * screenScale, qrImage.size.height * screenScale);
    
    /*
     使用指定的选项创建' bitmap-based '的图形上下文。
     您使用此函数配置绘制环境以呈现为'bitmap'。
     'bitmap'的格式是使用主机字节顺序的ARGB 32位整数像素格式。如果opaque参数为YES，那么将忽略alpha通道，并将位图视为完全不透明的（kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host）。否则，每个像素使用预乘的ARGB格式（kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host）。
     环境还使用UIKit视图的默认坐标系，其中原点在左上角，正轴向下延伸到原点的右边。
     所提供的比例因子也应用于坐标系和所得到的图像。绘图环境立即被推入图形上下文堆栈。
     虽然由此函数创建的上下文是当前上下文，但您可以调用UIGraphicsGetImageFromCurrentImageContext函数以基于上下文的当前内容检索图像对象。当完成修改上下文时，必须调用UIGraphicsEndImageContext函数来清除位图绘制环境，并从上下文栈顶部删除图形上下文。你不应该使用UIGraphicsPopContext函数从堆栈中删除这种类型的上下文。
     在大多数其他方面，由此函数创建的图形上下文与任何其他图形上下文一样。您可以通过推送和弹出其他图形上下文来更改上下文。您还可以使用UIGraphicsGetCurrentContext函数获取'bitmap'上下文。
     这个函数可以从你的应用程序的任何线程调用。
     参数
     size(尺寸)
     新'bitmap'上下文的大小（以点为单位）。这表示由UIGraphicsGetImageFromCurrentImageContext函数返回的图像的大小。要获取位图的大小（以像素为单位），必须将width和height值乘以scale参数中的值。
     opaque(不透明)
     指示位图是否不透明的布尔标志。如果您知道位图是完全不透明的，请指定YES以忽略Alpha通道并优化位图的存储。指定NO意味着位图必须包括一个Alpha通道来处理任何部分透明的像素。
     scale(规模)
     应用于位图的比例因子。如果指定的值为0.0，则比例因子设置为设备主屏幕的比例因子。
     */
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, screenScale);
    
    /*
     在指定的矩形中绘制整个图像，根据需要缩放以适应。
     此方法在当前图形上下文中绘制整个图像，并遵守图像的方向设置。 在默认坐标系中，图像位于指定矩形原点的下方和右侧。 然而，该方法遵守应用于当前图形上下文的任何变换。
     此方法使用kCGBlendModeNormal(将源图像样本绘制在背景图像样本上。)混合模式以完全不透明度绘制图像。
     参数
     rect
     绘制图像的矩形（在图形上下文的坐标系中）。
     */
    [qrImage drawInRect:rect];
    /*
     [qrImage drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y)];
     在当前上下文中的指定点绘制图像。
     此方法在当前图形上下文中绘制整个图像，并遵守图像的方向设置。 在默认坐标系中，图像位于指定点的下方和右侧。 然而，该方法遵守应用于当前图形上下文的任何变换。
     此方法使用kCGBlendModeNormal混合模式以完全不透明度绘制图像。
     参数
     point(点)
     绘制图像左上角的点。
     */
    
    CGSize avatarSize = CGSizeMake(rect.size.width * scale, rect.size.height * scale);
    CGFloat x = (rect.size.width - avatarSize.width) * 0.5;
    CGFloat y = (rect.size.height - avatarSize.height) * 0.5;
    [avatar drawInRect:CGRectMake(x, y, avatarSize.width, avatarSize.height)];
    
    /*
     返回基于当前'bitmap'的图形上下文的内容的图像。
     只有当基于位图的图形上下文是当前图形上下文时，才应调用此函数。 如果当前上下文为nil或者不是通过调用UIGraphicsBeginImageContext创建的，则此函数返回nil。
     这个函数可以从你的应用程序的任何线程调用。
     返回
     包含当前位图图形上下文内容的图像对象。
     */
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    /*
     从堆栈顶部删除当前基于位图的图形上下文。
     您使用此函数来清理由UIGraphicsBeginImageContext函数放置的绘图环境，并从堆栈顶部删除对应的基于位图的图形上下文。 如果当前上下文没有使用UIGraphicsBeginImageContext函数创建，则此函数不执行任何操作。
     这个函数可以从你的应用程序的任何线程调用。
     */
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:result.CGImage scale:screenScale orientation:UIImageOrientationUp];
}

@end
