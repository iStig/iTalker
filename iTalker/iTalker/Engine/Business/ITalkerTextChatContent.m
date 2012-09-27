//
//  ITalkerTextChatContent.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-27.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerTextChatContent.h"

@implementation ITalkerTextChatContent

- (id)init
{
    self = [super initWithType:ITalkerChatContentTypeText];
    if (self) {
        
    }
    
    return self;
}

- (id)initWIthData:(NSData *)data
{
    self = [self init];
    if (self) {
        _textContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return self;
}

@end
