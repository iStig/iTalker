//
//  ITalkerChatBaseEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatEngine.h"
#import "ITalkerMwConst.h"

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
        _tcpNetworkEngine = [[ITalkerTcpNetworkEngine alloc] init];
        [_tcpNetworkEngine acceptPort:kChatAcceptPort];
    }
    return self;
}

- (void)startChatWith:(ITalkerUserInfo *)userInfo
{
    
}

- (void)stopChatWith:(ITalkerUserInfo *)userInfo
{
    
}

@end
