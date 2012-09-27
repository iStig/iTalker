//
//  ITalkerBaseChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-26.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerBaseChatContent.h"

@implementation ITalkerBaseChatContent

- (id)initWithType:(ITalkerChatContentType)type
{
    self = [super init];
    if (self) {
        _contentType = type;
    }
    
    return self;
}

@end
