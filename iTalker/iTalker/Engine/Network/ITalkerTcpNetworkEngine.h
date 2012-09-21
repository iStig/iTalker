//
//  ITalkerTcpNetworkEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"

@protocol ITalkerTcpNetworkDelegate <NSObject>

@optional
- (void)handleTcpData:(NSData *)data;

@end

@interface ITalkerTcpNetworkEngine : NSObject <AsyncSocketDelegate> {
    AsyncSocket * _tcpSocket;
}

- (BOOL)acceptPort:(UInt16)port;

- (BOOL)connectHost:(NSString *)hostIpAddr onPort:(UInt16)port;

- (void)sendData:(NSData *)data ToHost:(NSString *)hostIpAddr;

@property (assign, nonatomic) id<ITalkerTcpNetworkDelegate> networkDelegate;

@end
