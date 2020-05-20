//
//  VideoH264Configuration.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN
/**
 视频分辨率
 */
typedef NS_ENUM (NSUInteger, H264VideoSessionPreset)
{
    
    H264CaptureSessionPreset360x640 = 0,
    
    H264CaptureSessionPreset540x960 = 1,
    
    H264CaptureSessionPreset720x1280 = 2
};

/**
 视频质量（VideoQuality_Default为默认配置）
 */
typedef NS_ENUM (NSUInteger, H264VideoQuality)
{
    H264VideoQuality_Low1 = 0,
    
    H264VideoQuality_Low2 = 1,
    
    H264VideoQuality_Low3 = 2,
    
    H264VideoQuality_Medium1 = 3,
    
    H264VideoQuality_Medium2 = 4,
    
    H264VideoQuality_Medium3 = 5,
    
    H264VideoQuality_High1 = 6,
    
    H264VideoQuality_High2 = 7,
    
    H264VideoQuality_High3 = 8,
    
    H264VideoQuality_Default = H264VideoQuality_Low2
};

/**
 视频编码配置项
 */
@interface VideoH264Configuration : NSObject<NSCoding, NSCopying>

/**
 默认视频配置
 
 @return
 */
+ (instancetype)defaultConfiguration;

/**
 视频配置(质量)
 
 @param videoQuality 视频质量
 @return
 */
+ (instancetype)defaultConfigurationForQuality:(H264VideoQuality)videoQuality;
/**
 视频配置(质量&是否是横屏)
 
 @param videoQuality 视频质量
 @param outputImageOrientation 屏幕方向
 @return
 */
+ (instancetype)defaultConfigurationForQuality:(H264VideoQuality)videoQuality outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation;

/**
 视频的分辨率，宽高务必设定为2的倍数，否则解码播放时可能出现绿边
 */
@property (nonatomic, assign) CGSize videoSize;

/**
 视频的帧率
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/**
 最大关键帧间隔，默认为帧率的3倍
 */
@property (nonatomic, assign) NSUInteger videoMaxKeyframeInterval;

/**
 视频的码率，单位是bps
 */
@property (nonatomic, assign) NSUInteger videoBitRate;

/**
 视频的最大码率，单位是bps
 */
@property (nonatomic, assign) NSUInteger videoMaxBitRate;

/**
 视频的最小码率，单位是bps
 */
@property (nonatomic, assign) NSUInteger videoMinBitRate;

/**
 分辨率
 */
@property (nonatomic, assign) H264VideoSessionPreset sessionPreset;

/**
 采集分辨率
 */
@property (nonatomic, assign, readonly) NSString *avSessionPreset;

/**
 编码时使用的清晰等级。默认情况下使用 kVTProfileLevel_H264_Baseline_4_0，如果对于视频编码有额外的需求并且知晓该参数带来的影响可以自行更改。
 
 */
@property (nonatomic, copy) NSString *videoProfileLevel;
@end

NS_ASSUME_NONNULL_END
