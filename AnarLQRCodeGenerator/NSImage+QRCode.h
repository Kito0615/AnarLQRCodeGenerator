//
//  NSImage+QRCode.h
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  颜色结构体，用来表示二维码的前景色和背景色
 */
typedef struct QRCodeColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} QRCodeForeColor, QRCodeBackgroundColor;

@interface NSImage (QRCode)

/**
 *  文本生成二维码
 *
 *  @param text 文本
 *
 *  @return 二维码图片
 */
+ (NSImage *)QRCodeWithText:(NSString *)text;

/**
 *  文本生成指定大小的二维码
 *
 *  @param text 文本
 *  @param size 二维码大小
 *
 *  @return 二维码图片
 */
+ (NSImage *)QRCodeWithText:(NSString *)text size:(CGFloat)size;

/**
 *  文本生成指定大小和前、背景颜色的二维码
 *
 *  @param text            文本
 *  @param size            二维码大小
 *  @param foreColor       前景色
 *  @param backgroundColor 背景色
 *
 *  @return 二维码图片
 */
+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(NSColor *)foreColor QRCodeBackgroundColor:(NSColor *)backgroundColor;

/**
 *  文本和图标生成指定大小和前、背景颜色的二维码
 *
 *  @param text            文本
 *  @param size            二维码大小
 *  @param foreColor       前景色
 *  @param backgroundColor 背景色
 *  @param icon            图标
 *
 *  @return 二维码图片
 */
+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(NSColor *)foreColor QRCodeBackgroundColor:(NSColor *)backgroundColor userIcon:(NSImage *)icon;

+ (NSString *)QRCodeContentWithQRCodeImage:(NSImage *)qrCodeImage;

@end
