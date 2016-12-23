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
    NSColor * _bgcolor;
    NSColor * _fgcolor;
    
    NSOpenPanel * _openPanel;
    NSImage * _icon;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.textview.font = [NSFont systemFontOfSize:24];
    _bgcolor = self.backgroundColorWell.color;
    _fgcolor = self.foregroundColorWell.color;
    
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

- (IBAction)openQRCode:(id)sender {
    NSOpenPanel * op = [NSOpenPanel openPanel];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:@[@"jpg", @"jpeg", @"png"]];
    [op setCanChooseDirectories:NO];
    [op beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL * imgURL = [op.URLs firstObject];
            NSImage * qrCode = [[NSImage alloc] initWithContentsOfURL:imgURL];
            NSString * content = [NSImage QRCodeContentWithQRCodeImage:qrCode];
            self.textview.string = [NSString stringWithFormat:@"识别结果:\n%@", content];
        }
    }];
}

- (NSImage *)createQRCode
{
    if (self.textview.string.length == 0) {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setInformativeText:@"请输入要生成二维码的内容!"];
        [alert addButtonWithTitle:@"确定"];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            NSLog(@"%ld", returnCode);
            
        }];
        
        return nil;
        
    }
    
    if (!_icon) {
        NSImage * QRCode = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:_fgcolor QRCodeBackgroundColor:_bgcolor];
        return QRCode;
    } else {
        NSImage * QRCode = [NSImage QRCodeWithText:self.textview.string QRCodeSize:self.QRCode.bounds.size.width QRCodeForeColor:_fgcolor QRCodeBackgroundColor:_bgcolor userIcon:_icon];
        return QRCode;
    }
}

- (void)bgColorAction:(NSColorWell *)sender
{
    _bgcolor = sender.color;
//    self.QRCode.image = [self createQRCode];
}

- (void)fgColorAction:(NSColorWell *)sender
{
    _fgcolor = sender.color;
//    self.QRCode.image = [self createQRCode];
}

@end
