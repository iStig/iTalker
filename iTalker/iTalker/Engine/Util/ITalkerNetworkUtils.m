//
//  ITalkerUtils.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-9.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerNetworkUtils.h"

@implementation ITalkerNetworkUtils

+ (NSData *)generateNetworkDataByData:(NSData *)data
{
    if (data == nil) {
        return  nil;
    }
    
    __autoreleasing NSMutableData * retData = [[NSMutableData alloc] init];
    NSInteger len = [data length];
    
    [retData appendBytes:&len length:sizeof(NSInteger)];
    [retData appendData:data];
    
    return retData;
}

+ (NSData *)generateNetworkDataByString:(NSString *)string
{
    if (string == nil) {
        return  nil;
    }
    
    __autoreleasing NSMutableData * retData = [[NSMutableData alloc] init];
    NSData * strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = [strData length];
    
    [retData appendBytes:&len length:sizeof(NSInteger)];
    [retData appendData:strData];
    
    return retData;
}

+ (NSData *)generateNetworkDataByInt:(NSInteger)intValue
{
    __autoreleasing NSMutableData * retData = [[NSMutableData alloc] init];
    NSString * string = [NSString stringWithFormat:@"%d", intValue];
    NSData * strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = [strData length];
    
    [retData appendBytes:&len length:sizeof(NSInteger)];
    [retData appendData:strData];
    
    return retData;
}

@end
