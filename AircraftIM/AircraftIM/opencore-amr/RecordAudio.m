//
//  RecordAudio.m
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h> 

@implementation RecordAudio
@synthesize recorder;
@synthesize avPlayer;

- (void)dealloc {
    [recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
    [avPlayer stop];
    [avPlayer release];
    avPlayer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(id)init {
    self = [super init];
    if (self) {
        _audioSession = [AVAudioSession sharedInstance];

//        [_audioSession setMode:AVAudioSessionModeMeasurement error:nil];
        
//        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);

        //Activate the session
//        [_audioSession setActive:YES error: &error];
    }
    return self;
}

- (void)enabledProximityMonitoring
{
    //要确定近距离传感器是否可用，可以尝试启用它，即 proximityMonitoringEnabled ＝ YES，如果设置的属性值仍然为NO，说明传感器不可用。
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proximitySensorChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

//近距离传感器 状态变化后调用的函数
- (void)proximitySensorChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");

        //在此写接近时，要做的操作逻辑代码
        
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];  //听筒模式
    
    }else{
        NSLog(@"Device is not close to user");
        //是否已默认开启听筒模式
        if (![userDefaults objectForKey:@"telephoneReceiver"]) {
            [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
        
        if (!avPlayer || !avPlayer.isPlaying) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (BOOL)activePlayAudioSession
{
    //设置输出对象，是否插入耳机
    BOOL hasHeadset = [UIDevice headphonesConnected];
    NSLog (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    UInt32 audioRouteOverride = hasHeadset?kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    //是否已默认开启听筒模式
    if ([userDefaults objectForKey:@"telephoneReceiver"]) {
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    }else{
        [_audioSession setCategory:AVAudioSessionCategoryPlayback error: &error];
    }
    
    return [self activeAudioSession];
}

- (BOOL)activeRecordAudioSession
{
    [_audioSession setCategory:AVAudioSessionCategoryRecord error: &error];
    return [self activeAudioSession];
}

- (BOOL)activeAudioSession
{
    NSError *sessionError = nil;
    [_audioSession setActive:YES error:&sessionError];
    
    if (sessionError) {
        NSLog(@"active AudioSession error: %@",sessionError);
        return false;
    }
    return true;
}

- (BOOL)deactiveAudioSession
{
    NSError *sessionError = nil;
    [_audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&sessionError];
    
    if (sessionError) {
        NSLog(@"deactive AudioSession error: %@",sessionError);
        return false;
    }
    return true;
}

- (NSURL *)stopRecord
{
    if (!recorder) {
        return nil;
    }
    NSURL *url = [[NSURL alloc]initWithString:recorder.url.absoluteString];
    [recorder stop];
    [recorder release];
    recorder =nil;
    
    [self deactiveAudioSession];
    return [url autorelease];
}

+ (NSTimeInterval)getAudioTime:(NSData *) data
{
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    [play release];
    return n;
}

//0 播放 1 播放完成 2出错
-(void)sendStatus:(PlayStatus)status
{
    if ([self.delegate respondsToSelector:@selector(audioPlayer:playStatus:)]) {
        [self.delegate audioPlayer:avPlayer playStatus:status];
    }
}

- (void)stopPlayAmr
{
    if (avPlayer!=nil) {
        [avPlayer stop];
        [avPlayer release];
        avPlayer = nil;
    }
    
    [self deactiveAudioSession];
    
    if (![[UIDevice currentDevice] proximityState]) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

- (NSData *)decodeAmr:(NSData *)data
{
    if (!data) {
        return data;
    }
    return DecodeAMRToWAVE(data);
}

- (void)playAmrData:(NSData*)data volume:(int)volume
{
	//Setup the AVAudioPlayer to play the file that we just recorded.
    [self stopPlayAmr];
    
    NSData *decodedData = [self decodeAmr:data]; // decoded data
    avPlayer = [[AVAudioPlayer alloc] initWithData:decodedData error:&error];
    avPlayer.delegate = self;

	[avPlayer prepareToPlay];
    [avPlayer setVolume:volume];
    
    [self activePlayAudioSession];
    
	if(![avPlayer play]){
        [self sendStatus:Status_PlayError];
    } else {
        [self sendStatus:Status_Playing];
    
        if (![UIDevice headphonesConnected]) {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        }
    }
}

- (void)pausePlayAmr
{
    if (avPlayer) {
        [avPlayer pause];
        
        [self deactiveAudioSession];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}
- (void)playAmr
{
    if (avPlayer) {
        [self activePlayAudioSession];
        [avPlayer play];
        
        if (![UIDevice headphonesConnected]) {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        }
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)aRecorder error:(NSError *)aError
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecorderEncodeErrorDidOccur:error:)]) {
        [self.delegate audioRecorderEncodeErrorDidOccur:aRecorder error:aError];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:successfully:)]) {
        [self.delegate audioRecorderDidFinishRecording:aRecorder successfully:flag];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlayAmr];

    [self sendStatus:Status_PlayOver];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self stopPlayAmr];
    
    [self sendStatus:Status_PlayError];
}

- (void)startRecord
{
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    NSString *fileName = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"];
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
//    NSLog(@"Using File called: %@",recordedTmpFile);
    
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    [recorder setDelegate:self];
    [recorder setMeteringEnabled:YES];
    [recorder prepareToRecord];
    [recorder record];
    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
}

@end
