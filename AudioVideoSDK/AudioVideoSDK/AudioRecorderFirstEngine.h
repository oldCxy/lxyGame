//
//  AudioRecorderFirstEngine.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioRecordSampleBase.h"
#import "AudioVideoSampleProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface AudioRecorderFirstEngine : AudioRecordSampleBase<AudioVideoSampleProtocol>

@property (nonatomic, strong) id<AudioVideoSampleProtocol> audioVideoProtocol;

/**
 是否开启自动播放，录音停止后自动播放，默认YES
 */
@property (nonatomic, assign) BOOL isAutomaticPlay;

/**
 是否开启音频声波定时器,默认开启
 */
@property (nonatomic, assign) BOOL isAcousticTimer;

- (void)startRecord;

- (void)pauaseRecord;

- (void)playRecord;

- (void)stopRecord;

@end

NS_ASSUME_NONNULL_END
