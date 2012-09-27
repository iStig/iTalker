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
    }
    return self;
}

#pragma mark - chat methods

- (void)startChatWith:(ITalkerUserInfo *)userInfo
{
    currentSocketId = [_networkEngine connectHost:userInfo.IpAddr OnPort:kChatAcceptPort];
    currentUserInfo = userInfo;
}

- (void)stopChatWith:(ITalkerUserInfo *)userInfo
{
    [_networkEngine disconnectSocketById:currentSocketId];
    currentUserInfo = nil;
}

- (void)sendData:(NSData *)data
{
    [_networkEngine sendData:data FromSocketById:currentSocketId];
}

#pragma mark - tcp network delegate methods

- (void)handleTcpData:(NSData *)data FromSocketId:(ITalkerTcpSocketId)socketId
{
    if (socketId == currentSocketId) {
        //TODO check if accept new socket header data
        
        if (_chatDelegate && [_chatDelegate respondsToSelector:@selector(handleNewMessage:From:)]) {
            ITalkerTextChatContent * chatContent = [[ITalkerTextChatContent alloc] init];
            [_chatDelegate handleNewMessage:chatContent From:currentUserInfo];
        }
    }
}

- (void)handleAcceptNewSocket:(ITalkerTcpSocketId)newSocketId
{
    currentSocketId = newSocketId;
}

- (void)handleTcpEvent:(ITalkerTcpNetworkEvent)event ForSocketId:(ITalkerTcpSocketId)socketId
{
    
}


@end
