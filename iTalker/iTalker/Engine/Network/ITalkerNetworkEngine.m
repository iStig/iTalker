//
//  ITalkerNetworkEngine.m
//  iTalker
//
//  Created by tuyuanlin on 12-8-31.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerNetworkEngine.h"

#define BindPortTag         1
#define SendUdpTag          2
#define SendDataTimeOut     30

@implementation ITalkerNetworkEngine

static ITalkerNetworkEngine * instance = nil;

+ (ITalkerNetworkEngine *)getInstance
{
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

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
    [_udpSocket receiveWithTimeout:-1 tag:BindPortTag];
    return YES;
}

- (BOOL)broadcastUdpData:(NSData *)data
{
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
        
    }
    
    [_udpSocket receiveWithTimeout:-1 tag:BindPortTag];
    return YES;
}

@end
