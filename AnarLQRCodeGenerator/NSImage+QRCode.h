//
//  NSImage+QRCode.h
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct QRCodeColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} QRCodeForeColor, QRCodeBackgroundColor;

@interface NSImage (QRCode)

+ (NSImage *)QRCodeWithText:(NSString *)text;

+ (NSImage *)QRCodeWithText:(NSString *)text size:(CGFloat)size;

+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(QRCodeForeColor)foreColor QRCodeBackgroundColor:(QRCodeBackgroundColor)backgroundColor;
+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(QRCodeForeColor)foreColor QRCodeBackgroundColor:(QRCodeBackgroundColor)backgroundColor userIcon:(NSImage *)icon;

@end
