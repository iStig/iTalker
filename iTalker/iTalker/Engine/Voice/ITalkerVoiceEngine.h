//
//  ITalkerVoiceEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-29.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ITalkerVoiceFileManager.h"

@interface ITalkerVoiceEngine : NSObject {
    AVAudioRecorder * _recorder;
    AVAudioPlayer * _player;
    ITalkerVoiceRecordId _curRecordId;
}

+ (ITalkerVoiceEngine *)getInstance;

- (void)recordVoice;

- (ITalkerVoiceRecordId)stopRecordVoice;

- (void)playVoiceByFileId:(ITalkerVoiceRecordId)voiceId;

- (void)playVoiceByData:(NSData *)data;

@end
