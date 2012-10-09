//
//  ITalkerVoiceChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-10-8.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerVoiceChatContent.h"

@implementation ITalkerVoiceChatContent

- (id)initWithVoiceData:(NSData *)data
{
    self = [super initWithType:ITalkerChatContentTypeVoice];
    if (self) {
        _voiceData = data;
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
    return [NSData dataWithData:_voiceData];
}

- (BOOL)deserialize:(NSData *)data
{
    _voiceData = [NSData dataWithData:data];
    return YES;
}

@end
