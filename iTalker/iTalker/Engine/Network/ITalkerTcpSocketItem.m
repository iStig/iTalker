//
//  ITalkerTcpNetworkItem.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTcpSocketItem.h"

@implementation ITalkerTcpSocketItem

- (BOOL)isEqualById:(ITalkerTcpSocketId)socketId;
{
    if (_socketId == socketId) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqualBySocket:(AsyncSocket *)socket
{
    if ([_socket isEqual:socket]) {
        return YES;
    }
    return NO;
}

@end
