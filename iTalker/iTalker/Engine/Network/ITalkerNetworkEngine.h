//
//  ITalkerNetworkEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-31.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@protocol ITalkerNetworkDelegate <NSObject>

@optional
- (void)handleUdpData:(NSData *)data;

@end

@interface ITalkerNetworkEngine : NSObject <AsyncUdpSocketDelegate>{
    AsyncUdpSocket * _udpSocket;
    UInt16 _currentPort;
}

+ (ITalkerNetworkEngine *)getInstance;

- (BOOL)bindPort:(UInt16)port;

- (BOOL)broadcastUdpData:(NSData *)data;

@property (strong, nonatomic) id<>

@end
