//
//  TCGBKString.m
//  TCGBKString
//
//  Created by changtang on 16/5/5.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

#import "TCGBKString.h"

@implementation TCGBKString

@end

// create gbk string by drop 4 byte code unit in gb18030 bytes
// https://zh.wikipedia.org/wiki/%E6%B1%89%E5%AD%97%E5%86%85%E7%A0%81%E6%89%A9%E5%B1%95%E8%A7%84%E8%8C%83
// https://zh.wikipedia.org/wiki/GB_18030
NSString *tcGBKString(NSString *string)
{
    if (string == nil) return nil;

    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:encoding allowLossyConversion:YES];
    if (data) {
        long length = data.length;
        unsigned char *bytes = (unsigned char *)data.bytes;
        NSMutableData *tmpData = [NSMutableData dataWithCapacity:data.length];
        int i = 0;
        while (i < length) {
            unsigned char byte1 = bytes[i], byte2 = (i+1<length) ? bytes[i+1] : 0;
            if (byte1 >= 0 && byte1 <=0x7f) {
                [tmpData appendBytes:&bytes[i] length:1];
                i += 1;
            }
            else if (byte1 >= 0x81 && byte1 < 0xfe) {
                if (byte2 >= 0x40 && byte2 <= 0xfe && byte2 != 0x7f) {
                    [tmpData appendBytes:&bytes[i] length:2];
                    i += 2;
                }
                else if (byte2 >= 0x30 && byte2 <= 0x39) {
                    // drop 4 bytes
                    i += 4;
                }
                else {
                    return nil;
                }
            }
            else {
                return nil;
            }
        }
        return [[NSString alloc] initWithData:tmpData encoding:encoding];
    }
    return nil;
}
