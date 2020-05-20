//
//  VideoFirstRecorder.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/14.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "VideoRecordSampleBase.h"

NS_ASSUME_NONNULL_BEGIN

//录制视频的长宽比
typedef NS_ENUM(NSInteger, VideoRecordViewType) {
    Type1X1 = 0,
    Type4X3,
    TypeFullScreen
};

//闪光灯状态
typedef NS_ENUM(NSInteger, VideoRecordFlashState) {
    VideoRecordFlashClose = 0,
    VideoRecordFlashOpen,
    VideoRecordFlashAuto,
};

//摄像头位置

typedef NS_ENUM(NSInteger, VideoRecordPosition) {
    VideoRecordPositionFront = 0,
    VideoRecordPositionBack,
    VideoRecordPositionUnspecified,
};

//录制状态
typedef NS_ENUM(NSInteger, VideoRecordState) {
    VideoRecordStateInit = 0,
    VideoRecordStateRecording,
    VideoRecordStatePause,
    VideoRecordStateFinish,
};

//控制录制的视频是否有声音
typedef NS_ENUM(NSInteger, VideoRecordVoiceType) {
    VideoRecordVoiceSoundType = 0,
    VideoRecordVoiceNoSoundType,
};


//录制视频的输出类型
typedef NS_ENUM(NSInteger, VideoRecordOutputType) {
    VideoRecordMovieFileOutput = 0,
    VideoRecordVideoDataOutput,
};


/**
 视频第一选择录制器
 */
@interface VideoFirstRecorder : VideoRecordSampleBase


@property (nonatomic, assign) VideoRecordPosition recordPosition;
@property (nonatomic, assign) VideoRecordVoiceType recordVoiceType;
@property (nonatomic, assign) VideoRecordOutputType recordOutputType;


/**
 将设备捕捉到的画面呈现到某个view上
 
 @param view 显示具体捕捉画面的视图
 */
- (void)showCaptureSessionOnView:(UIView *)view;

/**
 告诉接收器开始运行。
 */
- (void)startRunning;
/**
 告诉接收器停止运行。
 */
- (void)stopRunning;

//切换设备的摄像机位置
- (void)switchCameraDevicePosition;
@end

NS_ASSUME_NONNULL_END
