//
//  ITalkerChatBaseEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatEngine.h"
#import "ITalkerConst.h"
#import "ITalkerUserInfo.h"
#import "ITalkerTextChatContent.h"
#import "ITalkerAccountManager.h"
#import "JSONKit.h"
#import "ITalkerVoiceChatContent.h"

#define kTalkContentKeyUserInfo                     @"userinfo"
#define kTalkContentKeyContentType                  @"contenttype"
#define kTalkContentKeyContentData                  @"contentdata"

@implementation ITalkerChatEngine

static ITalkerChatEngine * instance;

+ (ITalkerChatEngine *)getInstance
{
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [ITalkerChatEngine getInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return [ITalkerChatEngine getInstance];
}

- (id)init
{
    self = [super init];
    if (self) {
        _networkEngine = [[ITalkerTcpNetworkEngine alloc] init];
        [_networkEngine acceptPort:kChatAcceptPort];
        _networkEngine.networkDelegate = self;
        _currentSocketId = kITalkerInvalidSocketId;
        _currentTalkToUserInfo = nil;
    }
    return self;
}

#pragma mark - chat methods

- (void)startChatWith:(ITalkerUserInfo *)userInfo
{
    if (_currentSocketId == kITalkerInvalidSocketId) {
        _currentSocketId = [_networkEngine connectHost:userInfo.IpAddr OnPort:kChatAcceptPort];
        _currentTalkToUserInfo = userInfo;
    }
}

- (void)stopChatWith:(ITalkerUserInfo *)userInfo
{
    if (_currentSocketId != kITalkerInvalidSocketId) {
        [_networkEngine disconnectSocketById:_currentSocketId];
        _currentTalkToUserInfo = nil;
    }
}

- (void)talk:(ITalkerBaseChatContent *)message
{
    if (message == nil && _currentSocketId == kITalkerInvalidSocketId) {
        return;
    }
    
    NSMutableDictionary * talkDic = [[NSMutableDictionary alloc] init];
    
    [self sendData:];
}

- (void)sendData:(NSData *)data
{
    if (_currentSocketId != kITalkerInvalidSocketId) {
        [_networkEngine sendData:data FromSocketById:_currentSocketId];
    }
}

#pragma mark - tcp network delegate methods

- (void)handleTcpData:(NSData *)data FromSocketId:(ITalkerTcpSocketId)socketId
{
    if (socketId == _currentSocketId) {
        if (_chatDelegate && [_chatDelegate respondsToSelector:@selector(handleNewMessage:From:)]) {
            JSONDecoder * jsonDecoder = [JSONDecoder decoder];
            NSDictionary * talkDic = [jsonDecoder objectWithData:data];
            
            ITalkerUserInfo * userInfo = [talkDic objectForKey:kTalkContentKeyUserInfo];
            NSData * contentData = [talkDic objectForKey:kTalkContentKeyContentData];
            NSNumber * contentType = [talkDic objectForKey:kTalkContentKeyContentType];
            
            switch (contentType.integerValue) {
                case ITalkerChatContentTypeText:
                {
                    ITalkerTextChatContent * chatContent = [[ITalkerTextChatContent alloc] initWithData:contentData];
                    [_chatDelegate handleNewMessage:chatContent From:userInfo];
                    break;
                }
                case ITalkerChatContentTypeVoice:
                {
                    ITalkerVoiceChatContent * chatContent = [[ITalkerVoiceChatContent alloc] initWithVoiceData:contentData];
                    [_chatDelegate handleNewMessage:chatContent From:userInfo];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)handleAcceptNewSocket:(ITalkerTcpSocketId)newSocketId
{
    _currentSocketId = newSocketId;
}

- (void)handleTcpEvent:(ITalkerTcpNetworkEvent)event ForSocketId:(ITalkerTcpSocketId)socketId
{
    
}


@end
