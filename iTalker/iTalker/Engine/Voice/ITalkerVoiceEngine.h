//
//  ITalkerVoiceEngine.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-29.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ITalkerVoiceEngine : NSObject {
    AVAudioRecorder * _recorder;
    AVAudioPlayer * _player;
}

+ (ITalkerVoiceEngine *)getInstance;

- (void)recordVoice:(NSString *)filename;

- (void)stopRecordVoice;

- (void)playVoice:(NSString *)filename;

@end
