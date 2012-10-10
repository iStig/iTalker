//
//  ITalkerVoiceChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-8.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerVoiceChatContent.h"
#import "ITalkerNetworkUtils.h"

@implementation ITalkerVoiceChatContent

- (id)initWithData:(NSData *)data
{
    self = [super initWithType:ITalkerChatContentTypeVoice];
    if (self) {
        [self deserialize:data];
    }
    return self;
}

- (id)initWIthVoiceFileName:(NSString *)filename
{
    self = [super initWithType:ITalkerChatContentTypeVoice];
    if (self) {
        _voiceData = [NSData dataWithContentsOfFile:filename];
    }
    return self;
}

- (NSData *)serialize
{
    __autoreleasing NSMutableData * serializeData = [[NSMutableData alloc] init];
    [serializeData appendData:[super serialize]];
    [serializeData appendData:[ITalkerNetworkUtils encodeNetworkDataByData:_voiceData]];
    
    return serializeData;
}

- (NSInteger)deserialize:(NSData *)data
{
    NSInteger superLen = [super deserialize:data];
    NSInteger length = 0;
    
    _voiceData = [ITalkerNetworkUtils decodeDataByNetworkData:data From:superLen AndLength:&length];
    
    return superLen + length;
}

@end
