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
        _currentUserInfo = nil;
    }
    return self;
}

#pragma mark - chat methods

- (void)startChatWith:(ITalkerUserInfo *)userInfo
{
    if (_currentSocketId == kITalkerInvalidSocketId) {
        _currentSocketId = [_networkEngine connectHost:userInfo.IpAddr OnPort:kChatAcceptPort];
        _currentUserInfo = userInfo;
    }
}

- (void)stopChatWith:(ITalkerUserInfo *)userInfo
{
    if (_currentSocketId != kITalkerInvalidSocketId) {
        [_networkEngine disconnectSocketById:_currentSocketId];
        _currentUserInfo = nil;
    }
}

- (void)talk:(ITalkerBaseChatContent *)message
{
    if (message == nil && _currentSocketId == kITalkerInvalidSocketId) {
        return;
    }
    
    NSData * data = [message serialize];
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
        //TODO check if accept new socket header data
        
        if (_chatDelegate && [_chatDelegate respondsToSelector:@selector(handleNewMessage:From:)]) {
            ITalkerTextChatContent * chatContent = [[ITalkerTextChatContent alloc] initWithData:data];
            [_chatDelegate handleNewMessage:chatContent From:_currentUserInfo];
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
