//
//  AppDelegate.h
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImage+QRCode.h"
#import "MacAddress.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>


@property (weak) IBOutlet NSSlider *fgRed;
@property (weak) IBOutlet NSSlider *fgGreen;
@property (weak) IBOutlet NSSlider *fgBlue;

@property (weak) IBOutlet NSSlider *bgRed;
@property (weak) IBOutlet NSSlider *bgGreen;
@property (weak) IBOutlet NSSlider *bgBlue;

- (IBAction)generateQRCode:(NSToolbarItem *)sender;
- (IBAction)exportQRCode:(NSToolbarItem *)sender;

@property (unsafe_unretained) IBOutlet NSTextView *textview;

@property (weak) IBOutlet NSImageView *QRCode;
- (IBAction)addIcon:(NSToolbarItem *)sender;
@end

