//
//  AppDelegate.h
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImage+QRCode.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)bgColorAction:(NSColorWell *)sender;
- (IBAction)fgColorAction:(NSColorWell *)sender;
@property (weak) IBOutlet NSColorWell *foregroundColorWell;
@property (weak) IBOutlet NSColorWell *backgroundColorWell;

- (IBAction)generateQRCode:(NSToolbarItem *)sender;
- (IBAction)exportQRCode:(NSToolbarItem *)sender;

@property (unsafe_unretained) IBOutlet NSTextView *textview;

@property (weak) IBOutlet NSImageView *QRCode;
- (IBAction)addIcon:(NSToolbarItem *)sender;
- (IBAction)removeIcon:(NSToolbarItem *)sender;
@end

