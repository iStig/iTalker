//
//  ITalkerUtils.h
//  iTalker
//
//  Created by tuyuanlin on 12-10-9.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITalkerNetworkUtils : NSObject

+ (NSData *)generateNetworkDataByData:(NSData *)data;

+ (NSData *)generateNetworkDataByString:(NSString *)string;

+ (NSData *)generateNetworkDataByInt:(NSInteger)intValue;

@end
