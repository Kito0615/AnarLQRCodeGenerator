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
    NSImage * _icon;
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
    
    self.QRCode.image = [self createQRCode];
    
}

- (IBAction)exportQRCode:(NSToolbarItem *)sender {
    
    NSImage * QRCode = [self createQRCode];
    
    if (!QRCode) {
        return;
    }
    
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
    self.QRCode.image = [self createQRCode];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)addIcon:(NSToolbarItem *)sender {
    
    _openPanel = [NSOpenPanel openPanel];
    _openPanel.directoryURL = [NSURL URLWithString:NSHomeDirectory()];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:NO];
    [_openPanel setAllowedFileTypes:@[@"png", @"jpg", @"tiff"]];
    
    [_openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSString * pngPath = [[[_openPanel URLs] lastObject] path];
            
            _icon = [[NSImage alloc] initWithContentsOfFile:pngPath];
            
            
            QRCodeForeColor foreColor;
            foreColor.red = self.fgRed.floatValue;
            foreColor.green = self.fgGreen.floatValue;
            foreColor.blue = self.fgBlue.floatValue;
            
            QRCodeBackgroundColor backgroundColor;
            backgroundColor.red = self.bgRed.floatValue;
            backgroundColor.green = self.bgGreen.floatValue;
            backgroundColor.blue = self.bgBlue.floatValue;
            
            self.QRCode.image = [self createQRCode];
            
        }
    }];
    
}

- (IBAction)removeIcon:(NSToolbarItem *)sender {
    if (_icon) {
        _icon = nil;
        self.QRCode.image = [self createQRCode];
    }
}

- (NSImage *)createQRCode
{
    if (self.textview.string.length == 0) {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setInformativeText:@"请输入要生成二维码的内容!"];
        [alert addButtonWithTitle:@"确定"];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        
        return nil;
        
    }
    QRCodeForeColor foreColor;
    foreColor.red = self.fgRed.floatValue;
    foreColor.green = self.fgGreen.floatValue;
    foreColor.blue = self.fgBlue.floatValue;
    
    QRCodeBackgroundColor backgroundColor;
    backgroundColor.red = self.bgRed.floatValue;
    backgroundColor.green = self.bgGreen.floatValue;
    backgroundColor.blue = self.bgBlue.floatValue;
    
    if (!_icon) {
        NSImage * QRCode = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor];
        return QRCode;
    } else {
        NSImage * QRCode = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:foreColor QRCodeBackgroundColor:backgroundColor userIcon:_icon];
        return QRCode;
    }
}

@end
