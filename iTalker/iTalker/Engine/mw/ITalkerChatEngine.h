//
//  ITalkerChatBaseEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ITalkerTcpNetworkEngine.h"

@class ITalkerUserInfo;

@protocol ITalkerChatDelegate <NSObject>
    
@optional
- (void)handleNewMessage:(NSData *)data From:(ITalkerUserInfo *)userInfo;

@end

@interface ITalkerChatEngine : NSObject <ITalkerTcpNetworkDelegate> {
    ITalkerTcpNetworkEngine * _tcpNetworkEngine;
}

+ (ITalkerChatEngine *)getInstance;

- (void)startChatWith:(ITalkerUserInfo *)userInfo;

- (void)stopChatWith:(ITalkerUserInfo *)userInfo;

@property (assign, nonatomic) id<ITalkerChatDelegate> chatDelegate;

@end
