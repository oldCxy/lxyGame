//
//  AudioVideoSampleProtocol.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioVideoSampleProtocol <NSObject>

@optional

#pragma mark -- 音视频共有
/**音视频的录制进度*/
- (void)audioVideoRecordProgress:(CGFloat)progress;

/**
 音视频的录制完成回调

 @param state 录制完成的状态，成功、失败
 @param outputPath 音视频的输出地址
 @param recordTimeLength 录制音视频的总时长
 */
- (void)audioVideoRecorderDidFinishState:(NSInteger)state outputPath:(NSString *)outputPath recordTimeLength:(NSUInteger)recordTimeLength;

/**
 音视频的录制完成回调
 
 @param state 录制完成的状态，成功、失败
 */
- (void)audioVideoRecorderWillStartState:(NSInteger)state;

/**音视频的播放完成回调*/
- (void)audioVidepPlayerDidFinishPlaying:(id)player successfully:(BOOL)flag;

/**音视频的自动停止录制回调*/
- (void)audioVidepRecorderDidAutomaticStopRecording:(id)recorder;

#pragma mark -- 音频私有
/**音频的声波监控*/
- (void)audioPowerChangeProgress:(CGFloat)progress;

/**开始录制音频*/
- (void)audioStartRecording;


@end

NS_ASSUME_NONNULL_END
