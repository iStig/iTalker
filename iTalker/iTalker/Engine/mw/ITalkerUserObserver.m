//
//  ITalkerUserObserver.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-19.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerUserObserver.h"
#import "ITalkerNetworkInfo.h"
#import "JSONKit.h"
#import "ITalkerMwConst.h"
#import "ITalkerUserInfo.h"

#define kPublishInfoKeyType                     @"type"
#define kPublishInfoValueTypeAddUser            @"adduser"
#define kPublishInfoValueTypeRemoveUser         @"removeuser"

#define kPublishInfoKeyUserInfo                 @"userinfo"

@implementation ITalkerUserObserver

static ITalkerUserObserver * instance = nil;

+ (ITalkerUserObserver *)getInstance
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

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _udpNetworkEngine = [[ITalkerUdpNetworkEngine alloc] init];
        _udpNetworkEngine.networkDelegate = self;
    }
    return self;
}

- (void)startObserve
{
    [_udpNetworkEngine bindPort:kUserObserverPort];
    [_udpNetworkEngine waitForData];
}

- (void)publishUser:(ITalkerUserInfo *)userInfo
{
    if (userInfo == nil) {
        return;
    }
    
    [_udpNetworkEngine broadcastUdpData:[self composePublishInfo:userInfo WithType:kPublishInfoValueTypeAddUser]];
}

- (void)handleUdpData:(NSData *)data
{    
    if (data && _userEventDelegate && [_userEventDelegate respondsToSelector:@selector(handleUserObserverEvent:AndUserInfo:)]) {

        JSONDecoder * jsonDecoder = [JSONDecoder decoder];
        NSDictionary * userEventDic = [jsonDecoder objectWithData:data];
        
        if (userEventDic) {
            NSString * type = [userEventDic objectForKey:kPublishInfoKeyType];
            
            ITalkerUserObserverEvent event;
            if ([type compare:kPublishInfoValueTypeAddUser options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                event = ITalkerUserObserverUserAdded;
            } else {
                event = ITalkerUserObserverUserRemoved;
            }
            
            NSDictionary * userInfoDic = [userEventDic objectForKey:kPublishInfoKeyUserInfo];
            if (userInfoDic) {
                ITalkerUserInfo * userInfo = [[ITalkerUserInfo alloc] init];
                [userInfo deserialize:userInfoDic];
                [_userEventDelegate handleUserObserverEvent:event AndUserInfo:userInfo];
            }
        }
    }
    
    [_udpNetworkEngine waitForData];
}

- (NSData *)composePublishInfo:(ITalkerUserInfo *)userInfo WithType:(NSString *)publishType
{
    NSDictionary * userInfoDic = [userInfo serialize];
    if (userInfoDic) {
        NSMutableDictionary * publishInfoDic = [[NSMutableDictionary alloc] init];
        [publishInfoDic setObject:publishType forKey:kPublishInfoKeyType];
        [publishInfoDic setObject:userInfoDic forKey:kPublishInfoKeyUserInfo];
        
        return [publishInfoDic JSONData];
    }
    return nil;
}

@end
