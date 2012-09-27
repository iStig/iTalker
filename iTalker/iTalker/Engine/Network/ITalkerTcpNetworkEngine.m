//
//  ITalkerTcpNetworkEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTcpNetworkEngine.h"
#import "ITalkerConst.h"

#define kSendTcpTag             1

static NSInteger staticIdCount = 0;

@implementation ITalkerTcpNetworkEngine

- (id)init
{
    self = [super init];
    if (self) {
        _socketItemArray = [[NSMutableArray alloc] init];
        _listenSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    return self;
}

- (BOOL)acceptPort:(UInt16)port
{
    return [_listenSocket acceptOnPort:port error:nil];
}

- (ITalkerTcpSocketId)connectHost:(NSString *)hostIpAddr OnPort:(UInt16)port;
{
    AsyncSocket * socket = [[AsyncSocket alloc] initWithDelegate:self];
    if ([socket connectToHost:hostIpAddr onPort:port withTimeout:kNetworkTimeOut error:nil]) {
        ITalkerTcpSocketItem * newItem = [[ITalkerTcpSocketItem alloc] initWithSocket:socket AndId:staticIdCount++];
        [_socketItemArray addObject:newItem];
        return newItem.socketId;
    }
    return kITalkerInvalidSocketId;
}

- (void)sendData:(NSData *)data FromSocketById:(ITalkerTcpSocketId)socketId;
{
    ITalkerTcpSocketItem * item = [self findSocketItemById:socketId];
    if (item) {
        [item.socket writeData:data withTimeout:kNetworkTimeOut tag:kSendTcpTag];
    }
}

- (void)disconnectSocketById:(ITalkerTcpSocketId)socketId;
{
    ITalkerTcpSocketItem * item = [self findSocketItemById:socketId];
    if (item) {
        [item.socket disconnect];
    }
}

- (ITalkerTcpSocketItem *)findSocketItemById:(ITalkerTcpSocketId)socketId
{
    for (ITalkerTcpSocketItem * item in _socketItemArray) {
        if ([item isEqualById:socketId]) {
            return item;
        }
    }
    return nil;
}

- (ITalkerTcpSocketItem *)findSocketItemBySocket:(AsyncSocket *)socket
{
    for (ITalkerTcpSocketItem * item in _socketItemArray) {
        if ([item isEqualBySocket:socket]) {
            return item;
        }
    }
    return nil;
}

#pragma mark - AsyncSocketDelegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    if (sock && [sock isEqual:_listenSocket]) {
        ITalkerTcpSocketItem * newItem = [[ITalkerTcpSocketItem alloc] initWithSocket:newSocket AndId:staticIdCount++];
        [_socketItemArray addObject:newItem];
        
        if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleAcceptNewSocket:)]) {
            [_networkDelegate handleAcceptNewSocket:newItem.socketId];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleTcpEvent:ForSocketId:)]) {
        ITalkerTcpSocketItem * item = [self findSocketItemBySocket:sock];
        if (item) {
            [_networkDelegate handleTcpEvent:ITalkerTcpNetworkEventConnected ForSocketId:item.socketId];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleTcpData:FromSocketId:)]) {
        ITalkerTcpSocketItem * item = [self findSocketItemBySocket:sock];
        if (item) {
            [_networkDelegate handleTcpData:data FromSocketId:item.socketId];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

@end
