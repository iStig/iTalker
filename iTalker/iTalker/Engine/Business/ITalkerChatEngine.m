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
#import "ITalkerNetworkUtils.h"

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
    NSMutableData * data = [[NSMutableData alloc] init];
    [data appendData:[ITalkerNetworkUtils encodeNetworkDataByData:[[_currentTalkToUserInfo serialize] JSONData]]];
    [data appendData:[message serialize]];
    
    [self sendData:data];
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
            NSInteger length = 0;
            NSData * userInfoData = [ITalkerNetworkUtils decodeDataByNetworkData:data From:0 AndLength:&length];
            
            NSData * chatData = [data subdataWithRange:NSMakeRange(length, [data length] - length)];
            NSDictionary * userInfoDic = [[JSONDecoder decoder] objectWithData:userInfoData];
            
            if (_currentTalkToUserInfo != nil) {
                _currentTalkToUserInfo = nil;
            }
            _currentTalkToUserInfo = [[ITalkerUserInfo alloc] init];
            [_currentTalkToUserInfo deserialize:userInfoDic];
            
            ITalkerBaseChatContent * content = [[ITalkerBaseChatContent alloc] init];
            [content deserialize:chatData];
            
            switch (content.contentType) {
                case ITalkerChatContentTypeText:
                {
                    ITalkerTextChatContent * chatContent = [[ITalkerTextChatContent alloc] initWithData:chatData];
                    [_chatDelegate handleNewMessage:chatContent From:_currentTalkToUserInfo];
                    break;
                }
                case ITalkerChatContentTypeVoice:
                {
                    ITalkerVoiceChatContent * chatContent = [[ITalkerVoiceChatContent alloc] initWithData:chatData];
                    [_chatDelegate handleNewMessage:chatContent From:_currentTalkToUserInfo];
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
