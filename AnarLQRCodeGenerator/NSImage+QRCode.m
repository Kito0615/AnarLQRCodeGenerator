//
//  NSImage+QRCode.m
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import "NSImage+QRCode.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSImage (QRCode)

void ProviderReleaseData(void * info, const void * data, size_t size)
{
    free((void *)data);
}

+ (NSImage *)QRCodeWithText:(NSString *)text
{
    CIFilter * qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    NSData * textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    [qrFilter setValue:textData forKey:@"inputMessage"];
    
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage * img = qrFilter.outputImage;
    
    NSCIImageRep * ciimageRep = [NSCIImageRep imageRepWithCIImage:img];
    
    NSImage * qrImage = [[NSImage alloc] initWithSize:ciimageRep.size];
    
    [qrImage addRepresentation:ciimageRep];
    
    return qrImage;
}

+ (NSImage *)QRCodeWithText:(NSString *)text size:(CGFloat)size
{
    NSImage * tempImage = [NSImage QRCodeWithText:text];
    
    NSData * tempImageData = [tempImage TIFFRepresentation];
    
    CIImage * tempCiimage = [CIImage imageWithData:tempImageData];
    
    CGRect extent = CGRectIntegral(tempCiimage.extent);
    
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef =CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:tempCiimage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [[NSImage alloc] initWithCGImage:scaledImage size:CGSizeMake(width, height)];
    
}


+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(QRCodeForeColor)foreColor QRCodeBackgroundColor:(QRCodeBackgroundColor)backgroundColor
{
    NSImage * img = [NSImage QRCodeWithText:text size:size];
    
    const int imageWidth = img.size.width;
    const int imageHeight = img.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    
    uint32_t * rgbImageRef = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageRef, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef)[img TIFFRepresentation], NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t * pCurPtr = rgbImageRef;
    
    for (int i = 0; i < pixelNum; i ++, pCurPtr ++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = foreColor.red;
            ptr[2] = foreColor.green;
            ptr[1] = foreColor.blue;
        } else {
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = backgroundColor.red;
            ptr[2] = backgroundColor.green;
            ptr[1] = backgroundColor.blue;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageRef, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef outputImageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    NSImage * QRImage = [[NSImage alloc] initWithCGImage:outputImageRef size:CGSizeMake(imageWidth, imageHeight)];
    
    return QRImage;
}

+ (NSImage *)QRCodeWithText:(NSString *)text QRCodeSize:(CGFloat)size QRCodeForeColor:(QRCodeForeColor)foreColor QRCodeBackgroundColor:(QRCodeBackgroundColor)backgroundColor userIcon:(NSImage *)icon
{
    NSImage * codeImage = [NSImage QRCodeWithText:text QRCodeSize:size QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor];
    
    const int imageWidth = codeImage.size.width;
    const int imageHeight = codeImage.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    
    uint32_t * rgbImageRef = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageRef, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)[codeImage TIFFRepresentation], NULL);
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    
    CGImageSourceRef iconSourceRef = CGImageSourceCreateWithData((CFDataRef)[icon TIFFRepresentation], NULL);
    CGImageRef iconRef = CGImageSourceCreateImageAtIndex(iconSourceRef, 0, NULL);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    
    int iconW = 45;
    int iconH = 45;
    
    int iconX = (imageWidth - iconW) / 2;
    int iconY = (imageHeight - iconH) / 2;
    
    CGContextDrawImage(context, CGRectMake(iconX, iconY, iconW, iconH), iconRef);
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageRef, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef outputImageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    NSImage * outputImage = [[NSImage alloc] initWithCGImage:outputImageRef size:CGSizeMake(imageWidth, imageHeight)];
    
    return outputImage;
    
    
}

@end
