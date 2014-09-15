//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AmrFileCodec.h"

typedef enum{
    Status_Playing = 0,       //正在播放
    Status_PlayOver = 1,      //播放完成
    Status_PlayError = 2      //出错
}PlayStatus;

@protocol RecordAudioDelegate <NSObject>
@optional
-(void)audioPlayer:(AVAudioPlayer *)player playStatus:(PlayStatus)status;

@optional
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error;
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;

@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	NSError * error;
}

@property (nonatomic, strong) AVAudioPlayer * avPlayer;
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVAudioSession * audioSession;

@property (nonatomic, assign) id<RecordAudioDelegate> delegate;

//可以使用近距离传感器
- (void)enabledProximityMonitoring;

//激活或关闭AudioSession
- (BOOL)activePlayAudioSession;
- (BOOL)activeRecordAudioSession;
- (BOOL)deactiveAudioSession;

- (NSURL *) stopRecord;
- (void) startRecord;

- (void)playAmrData:(NSData*)data volume:(int)volume;

- (void)playAmr;
- (void)pausePlayAmr;
- (void)stopPlayAmr;

- (NSData *)decodeAmr:(NSData *)data;
+ (NSTimeInterval)getAudioTime:(NSData *)data;

@end
