//
//  ITalkerChatBaseEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ITalkerTcpNetworkEngine.h"
#import "ITalkerBaseChatContent.h"

@class ITalkerUserInfo;

@protocol ITalkerChatDelegate <NSObject>
    
@optional
- (void)handleNewMessage:(ITalkerBaseChatContent *)message From:(ITalkerUserInfo *)userInfo;

@end

@interface ITalkerChatEngine : NSObject <ITalkerTcpNetworkDelegate> {
    ITalkerTcpNetworkEngine * _networkEngine;
    ITalkerTcpSocketId _currentSocketId;
    ITalkerUserInfo * _currentUserInfo;
}

+ (ITalkerChatEngine *)getInstance;

- (void)startChatWith:(ITalkerUserInfo *)userInfo;

- (void)stopChatWith:(ITalkerUserInfo *)userInfo;

- (void)talk:(ITalkerBaseChatContent *)message;

@property (assign, nonatomic) id<ITalkerChatDelegate> chatDelegate;

@end
