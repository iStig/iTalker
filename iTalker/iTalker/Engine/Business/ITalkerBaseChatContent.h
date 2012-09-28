//
//  ITalkerBaseChatContent.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-26.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ITalkerChatContentTypeText,
    ITalkerChatContentTypeVoice,
    ITalkerChatContentTypeImage
} ITalkerChatContentType;

@interface ITalkerBaseChatContent : NSObject

- (id)initWithType:(ITalkerChatContentType)type;

- (NSData *)serialize;

- (BOOL)deserialize:(NSData *)data;

@property (readonly, nonatomic) ITalkerChatContentType contentType;

@end
