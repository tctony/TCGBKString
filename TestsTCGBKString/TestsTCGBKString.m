//
//  TestsTCGBKString.m
//  TestsTCGBKString
//
//  Created by changtang on 16/5/5.
//  Copyright © 2016年 TCTONY. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreFoundation/CoreFoundation.h>

#import "TCGBKString.h"

@interface TestsTCGBKString : XCTestCase

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSString *filtered;

@end

@implementation TestsTCGBKString

- (void)setUp {
    [super setUp];

    self.string = @"哈哈😄";
    self.filtered = @"哈哈";
}

- (void)testWhatUp {
    [self _convertToEnoding:kCFStringEncodingGB_2312_80
               encodingName:@"GB2312"];
    [self _convertToEnoding:kCFStringEncodingGBK_95
               encodingName:@"GBK"];
    [self _convertToEnoding:kCFStringEncodingGB_18030_2000
               encodingName:@"GB18030"];
}

- (void)_convertToEnoding:(CFStringEncoding)cfEncoding encodingName:(NSString *)name
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    NSData *gbkData = [self.string dataUsingEncoding:encoding
                                allowLossyConversion:YES];
    NSLog(@"convert \"%@\" to encoding %@: %@", self.string, name, gbkData);
}

- (void)testGBKString
{
    XCTAssertTrue([self.filtered isEqualToString:tcGBKString(self.string)]);
    XCTAssertTrue([self.filtered isEqualToString:tcGBKString(self.filtered)]);
}

@end
