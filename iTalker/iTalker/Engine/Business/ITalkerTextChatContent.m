//
//  ITalkerTextChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTextChatContent.h"
#import "ITalkerNetworkUtils.h"

@implementation ITalkerTextChatContent

- (id)init
{
    self = [super initWithType:ITalkerChatContentTypeText];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithData:(NSData *)data
{
    self = [self init];
    if (self) {
        [self deserialize:data];
    }
    return self;
}

- (id)initWithString:(NSString *)str
{
    self = [self init];
    if (self) {
        _text = str;
    }
    return self;
}

- (BOOL)deserialize:(NSData *)data
{
    _text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return YES;
}

- (NSData *)serialize
{
    __autoreleasing NSMutableData * serializeData = [[NSMutableData alloc] init];
    [ITalkerNetworkUtils generateNetworkDataByInt:self.contentType];
    
    return [_text dataUsingEncoding:NSUTF8StringEncoding];
}

@end
