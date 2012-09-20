//
//  ITalkerNetworkEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-8-31.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerUdpNetworkEngine.h"

#define BindPortTag         1
#define SendUdpTag          2
#define SendDataTimeOut     30

@implementation ITalkerUdpNetworkEngine

@synthesize networkDelegate = _networkDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        _udpSocket = [[AsyncUdpSocket alloc] initIPv4];
        [_udpSocket setDelegate:self];
    }
    
    return self;
}

- (BOOL)bindPort:(UInt16)port
{
    NSError * err = nil;
    _currentPort = 0;
    
    [_udpSocket bindToPort:port error:&err];

    if (err) {
        NSLog(@"error = %@", err.localizedDescription);
        return NO;
    }
    
    _currentPort = port;

    return YES;
}

- (void)waitForData
{
    [_udpSocket receiveWithTimeout:-1 tag:BindPortTag];
}

- (BOOL)broadcastUdpData:(NSData *)data
{
    if (data == nil) {
        return NO;
    }
    
    NSError * err = nil;
    [_udpSocket enableBroadcast:YES error:&err];
    if (err) {
        NSLog(@"error = %@", err.localizedDescription);
        return NO;
    }
    
    return [_udpSocket sendData:data toHost:@"255.255.255.255" port:_currentPort withTimeout:SendDataTimeOut tag:SendUdpTag];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"receive udp data");
    
    if (tag == BindPortTag) {
        if (_networkDelegate && [_networkDelegate respondsToSelector:@selector(handleUdpData:)]) {
            [_networkDelegate handleUdpData:data];
        }
        return YES;
    }

    return NO;
}

@end
