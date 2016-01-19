//
//  AppDelegate.m
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/18/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    NSOpenPanel * _openPanel;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.textview.font = [NSFont systemFontOfSize:24];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)generateQRCode:(NSToolbarItem *)sender {
    
    QRCodeForeColor foreColor;
    foreColor.red = 0.0f;
    foreColor.green = 0.0f;
    foreColor.blue = 0.0f;
    
    QRCodeBackgroundColor backgroundColor;
    backgroundColor.red = 255.0f;
    backgroundColor.green = 255.0f;
    backgroundColor.blue = 255.0f;
    
    self.QRCode.image = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor];
    
}

- (IBAction)exportQRCode:(NSToolbarItem *)sender {
    
    QRCodeForeColor foreColor;
    foreColor.red = self.fgRed.floatValue;
    foreColor.green = self.fgGreen.floatValue;
    foreColor.blue = self.fgBlue.floatValue;
    
    QRCodeBackgroundColor backgroundColor;
    backgroundColor.red = self.bgRed.floatValue;
    backgroundColor.green = self.bgGreen.floatValue;
    backgroundColor.blue = self.bgBlue.floatValue;
    
    NSImage * QRCode = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor];
    
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];
    
    [_openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        if (result == NSOKButton) {
            NSURL * outputPath = [_openPanel.URLs lastObject];
            
            NSData * outputData = [QRCode TIFFRepresentation];
            
            [outputData writeToFile:[[outputPath path] stringByAppendingPathComponent:@"QRCode.png"] atomically:YES];
            
        }
        
    }];
    
}

- (IBAction)sliderValueChanged:(NSSlider *)slider
{
    QRCodeForeColor foreColor;
    foreColor.red = self.fgRed.floatValue;
    foreColor.green = self.fgGreen.floatValue;
    foreColor.blue = self.fgBlue.floatValue;
    
    QRCodeBackgroundColor backgroundColor;
    backgroundColor.red = self.bgRed.floatValue;
    backgroundColor.green = self.bgGreen.floatValue;
    backgroundColor.blue = self.bgBlue.floatValue;
    
    self.QRCode.image = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
