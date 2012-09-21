//
//  ITalkerTcpNetworkEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-21.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTcpNetworkEngine.h"
#import "ITalkerMwConst.h"

#define kSendTcpTag             1

@implementation ITalkerTcpNetworkEngine

- (id)init
{
    self = [super init];
    if (self) {
        _tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    return self;
}

- (BOOL)acceptPort:(UInt16)port
{
    return [_tcpSocket acceptOnPort:port error:nil];
}

- (BOOL)connectHost:(NSString *)hostIpAddr onPort:(UInt16)port
{
    return [_tcpSocket connectToHost:hostIpAddr onPort:port withTimeout:kNetworkSendDataTimeOut error:nil];
}

- (void)sendData:(NSData *)data ToHost:(NSString *)hostIpAddr
{
    [_tcpSocket writeData:data withTimeout:kNetworkSendDataTimeOut tag:kSendTcpTag];
}

#pragma mark - AsyncSocketDelegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

@end
