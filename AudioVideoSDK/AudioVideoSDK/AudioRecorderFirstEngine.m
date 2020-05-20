//
//  AudioRecorderFirstEngine.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioRecorderFirstEngine.h"

@interface AudioRecorderFirstEngine ()
<AVAudioRecorderDelegate,
AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioRecorder *recorder;//音频录制器
@property (nonatomic,strong) AVAudioPlayer *player;//音频播放器
@property (nonatomic,weak) NSTimer *timer;//定时器

@end

@implementation AudioRecorderFirstEngine


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isAutomaticPlay = YES;
        self.isAcousticTimer = YES;
//        [self initRecordSession];
    }
    return self;
}

/**
 *  初始化音频检查
 */
- (void)initRecordSession{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setActive:YES error:nil];
}

#pragma mark -- 懒加载初始化
- (AVAudioRecorder *)recorder{
    
    if (!_recorder) {
        
        /*
         url:录音文件保存的路径
         settings: 录音的设置
         error:错误
         */
        NSError *error;
        _recorder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath] settings:[self setAudioConfigure] error:&error];
        _recorder.delegate = self;
        //如果要监控声波则必须设置为YES
        _recorder.meteringEnabled = YES;
        if (error) {
            
            NSAssert(YES, @"录音机初始化失败,请检查参数");
        }
   
    }
    return _recorder;
}

- (AVAudioPlayer *)player{
    if (!_player) {
        
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getSavePath] error:&error];
        _player.delegate = self;
        
        //将播放文件加载到缓冲区
        [_player prepareToPlay];
        
        if (error) {
            
            NSAssert(YES, @"音频播放器初始化失败,请检查参数");
        }
    }
    return _player;
}

- (NSTimer *)timer{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(upDataProgress) userInfo:nil repeats:YES];
    }
    
    return _timer;
    
}//定时器


#pragma mark -- Action
- (void)upDataProgress{
    
    [self.recorder updateMeters];//更新测量值
    float power = [self.recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    if ([self.audioVideoProtocol respondsToSelector:@selector(audioPowerChangeProgress:)]) {
        [self.audioVideoProtocol audioPowerChangeProgress:progress];
    }
}

#pragma mark -- 开始录音
- (void)startRecord{
    
    if([self.recorder isRecording]) return;
    [self initRecordSession];
    //把录音文件加载到缓冲区,录制
    if ([self.recorder prepareToRecord] &&  [self.recorder record]) {
        
        if (self.isAutomaticStop) {//是否自动停止录制
            //开始录制声音，并且通过performSelector方法设置在录制声音maxRecordDelay以后执行stopRecordingOnAudioRecorder方法，用于停止录音
            [self performSelector:@selector(automaticStopRecord:)
                       withObject:self.recorder
                       afterDelay:self.maxRecordDelay];
        }
    }
    
    self.timer.fireDate = [NSDate distantPast];
}

#pragma mark -- 暂停录音
- (void)pauaseRecord{
    
    if(![self.recorder isRecording]) return;
    [self.recorder pause];
    //定时器触发的时机。暂停
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark -- 播放录音
- (void)playRecord{
    if (self.player.isPlaying) return;
    [self.player play];
}

#pragma mark -- 停止录音
- (void)stopRecord{
    
    //这句代码必须加在[self.recorder stop]之前，否则播放录制的音频声音会小到你听不见
//    [self setAudioSession];
    [self.recorder stop];
    
    //定时器触发的时机。停止
    self.timer.fireDate = [NSDate distantFuture];
    
    //停止录制将声波信号至0
    if ([self.audioVideoProtocol respondsToSelector:@selector(audioPowerChangeProgress:)]) {
        [self.audioVideoProtocol audioPowerChangeProgress:0];
    }
}

#pragma mark --  自动停止录制
- (void)automaticStopRecord:(AVAudioRecorder *)recorder{
    
    [self stopRecord];
    
    if ([self.audioVideoProtocol respondsToSelector:@selector(audioVidepRecorderDidAutomaticStopRecording:)]) {
        [self.audioVideoProtocol audioVidepRecorderDidAutomaticStopRecording:recorder];
    }
}

/**
 *  此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
 */
- (void)setAudioSession{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

#pragma mark -  AVAudioRecorder  Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    NSLog(@"录音完成");
    //是否在录制完成后自动播放
    if (_isAutomaticPlay) {
        [self playRecord];
    }
}//录音完成

#pragma mark - AVAudioPlayer  Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完成");
    
    self.recorder = nil;
    self.player = nil;
}//播放器完成

@end
