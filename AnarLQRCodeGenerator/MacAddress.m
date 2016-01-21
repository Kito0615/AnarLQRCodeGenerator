//
//  MacAddress.m
//  AnarLQRCodeGenerator
//
//  Created by AnarL on 1/20/16.
//  Copyright © 2016 AnarL. All rights reserved.
//

#import "MacAddress.h"

@implementation MacAddress

+ (NSString *)macAddress
{
    kern_return_t kr;
    CFMutableDictionaryRef matchDict;
    io_iterator_t iterator;
    io_registry_entry_t entry;
    
    matchDict = IOServiceMatching("IOEthernetInterface");
    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matchDict, &iterator);
    
    NSDictionary * resultInfo = nil;
    
    while ((entry = IOIteratorNext(iterator)) != 0) {
        CFMutableDictionaryRef properties = NULL;
        kr = IORegistryEntryCreateCFProperties(entry, &properties, kCFAllocatorDefault, kNilOptions);
        
        if (properties) {
            resultInfo = (__bridge_transfer NSDictionary *)properties;
            NSString * bsdName = [resultInfo objectForKey:@"BSD Name"];
            NSData * macData = [resultInfo objectForKey:@"IOMACAddress"];
            if (!macData) {
                continue;
            }
            
            NSMutableString * macAddress = [[NSMutableString alloc] init];
            
            const UInt8 * bytes = [macData bytes];
            for (int i = 0; i < macData.length; i ++) {
                [macAddress appendFormat:@"%02x", *(bytes + i)];
            }
            
            return [NSString stringWithFormat:@"NetCard : %@ \n Mac Address: %@", bsdName, macAddress];
        }
    }
    IOObjectRelease(iterator);
    return nil;
}

@end
