//
//  AudioVideoSampleBase.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , AudioVideoRecordingState) {
    AudioVideoRecordingStart,
    AudioVideoRecordingSuccess,
    AudioVideoRecordingFailed,
};


/**
 音视频录制的基础类
 */
@interface AudioVideoSampleBase : NSObject
/**定义实例变量*/
{

    NSFileManager *_audioVideoFileManager;
    NSString *_outputFileName;
    NSString *_saveSuffixFormat;
    BOOL _isAutomaticStop;
    NSUInteger _maxRecordDelay;
    NSTimeInterval _recordTimeLength;
}

/**定义属性变量*/

/**
 文件管理器
 */
@property (nonatomic,strong) NSFileManager *audioVideoFileManager;

/**
 保存到本地document下的文件路径名称
 */
@property (nonatomic,strong) NSString *outputFileName;

/**
 保存到本地document下的音视频文件格式：如：mp4、mov、aac、caf
 */
@property (nonatomic,strong) NSString *saveSuffixFormat;

/**
 保存到本地document下的音视频文件URL路径
 */
@property (nonatomic,strong,readonly) NSURL *savePathURL;

/**
 是否开启自动停止录制,默认是no
 */
@property (nonatomic, assign) BOOL isAutomaticStop;

/**
 自动停止录制的最大录制时间，默认0s,可以一直录制
 */
@property (nonatomic, assign) NSUInteger maxRecordDelay;

/**
 当前的录制音视频的总时长
 */
@property (nonatomic, assign) NSTimeInterval recordTimeLength;


#pragma mark -- 获取音视频保存的路径
- (NSURL *)getSavePath;

#pragma mark -- 清除本地存储的音视频数据数据
- (void)cleanFileCache;

@end

NS_ASSUME_NONNULL_END
