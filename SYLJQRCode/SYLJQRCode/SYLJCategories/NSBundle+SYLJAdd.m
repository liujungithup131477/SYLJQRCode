//
//  NSBundle+SYLJAdd.m
//  SYLJQRCode
//
//  Created by 刘俊 on 2017/1/14.
//  Copyright © 2017年 刘俊. All rights reserved.
//

#import "NSBundle+SYLJAdd.h"
#import "NSString+SYLJAdd.h"

#define SUPPORT_SCALES @[@3, @2, @1]

@implementation NSBundle (SYLJAdd)

+ (nullable NSString *)pathForScaledResource:(nullable NSString *)name ofType:(nullable NSString *)ext inDirectory:(nullable NSString *)bundlePath
{
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext inDirectory:bundlePath];
    
    NSString *path = nil;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = SUPPORT_SCALES.mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:bundlePath];
        if (path) break;
    }
    
    return path;
}

- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext];
    
    NSString *path = nil;
    
    // first search screen's scale, then search from high to low.
    NSMutableArray *scales = SUPPORT_SCALES.mutableCopy;
    NSInteger screenScale = [UIScreen mainScreen].scale;
    [scales removeObject:@(screenScale)];
    [scales insertObject:@(screenScale) atIndex:0];
    
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name stringByAppendingNameScale:scale]
        : [name stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:subpath];
        if (path) break;
    }
    
    return path;
}


@end
