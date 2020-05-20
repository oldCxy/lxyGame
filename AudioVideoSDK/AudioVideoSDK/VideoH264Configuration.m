//
//  VideoH264Configuration.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "VideoH264Configuration.h"


@implementation VideoH264Configuration

#pragma mark -- public methods
/**
 默认视频配置
 
 @return VideoH264Configuration
 */
+ (instancetype)defaultConfiguration{
    
    VideoH264Configuration *configuration = [VideoH264Configuration defaultConfigurationForQuality:H264VideoQuality_Default];
    return configuration;
}

/**
 视频配置(质量)
 
 @param videoQuality 视频质量
 @return VideoH264Configuration
 */
+ (instancetype)defaultConfigurationForQuality:(H264VideoQuality)videoQuality{
    
    VideoH264Configuration *configuration = [VideoH264Configuration defaultConfigurationForQuality:videoQuality outputImageOrientation:UIInterfaceOrientationPortrait];
    return configuration;
}
/**
 视频配置(质量&是否是横屏)
 
 @param videoQuality 视频质量
 @param outputImageOrientation 屏幕方向
 @return VideoH264Configuration
 */
+ (instancetype)defaultConfigurationForQuality:(H264VideoQuality)videoQuality outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation{
    
    VideoH264Configuration *configuration = [VideoH264Configuration new];
    switch (videoQuality)
    {
        case H264VideoQuality_Low1:
        {
            configuration.sessionPreset = H264CaptureSessionPreset360x640;
            configuration.videoFrameRate = 15;
            configuration.videoBitRate = 500 * 1000;
            configuration.videoMaxBitRate = 600 * 1000;
            configuration.videoMinBitRate = 400 * 1000;
            configuration.videoSize = CGSizeMake(360, 640);
        }
            break;
        case H264VideoQuality_Low2:
        {
            configuration.sessionPreset = H264CaptureSessionPreset360x640;
            configuration.videoFrameRate = 20;
            configuration.videoBitRate = 600 * 1000;
            configuration.videoMaxBitRate = 720 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(360, 640);
        }
            break;
        case H264VideoQuality_Low3:
        {
            configuration.sessionPreset = H264CaptureSessionPreset360x640;
            configuration.videoFrameRate = 30;
            configuration.videoBitRate = 800 * 1000;
            configuration.videoMaxBitRate = 960 * 1000;
            configuration.videoMinBitRate = 600 * 1000;
            configuration.videoSize = CGSizeMake(360, 640);
        }
            break;
        case H264VideoQuality_Medium1:
        {
            configuration.sessionPreset = H264CaptureSessionPreset540x960;
            configuration.videoFrameRate = 15;
            configuration.videoBitRate = 800 * 1000;
            configuration.videoMaxBitRate = 960 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(540, 960);
        }
            break;
        case H264VideoQuality_Medium2:
        {
            configuration.sessionPreset = H264CaptureSessionPreset540x960;
            configuration.videoFrameRate = 20;
            configuration.videoBitRate = 800 * 1000;
            configuration.videoMaxBitRate = 960 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(540, 960);
        }
            break;
        case H264VideoQuality_Medium3:
        {
            configuration.sessionPreset = H264CaptureSessionPreset540x960;
            configuration.videoFrameRate = 30;
            configuration.videoBitRate = 1000 * 1000;
            configuration.videoMaxBitRate = 1200 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(540, 960);
        }
            break;
        case H264VideoQuality_High1:
        {
            configuration.sessionPreset = H264CaptureSessionPreset720x1280;
            configuration.videoFrameRate = 15;
            configuration.videoBitRate = 1000 * 1000;
            configuration.videoMaxBitRate = 1200 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(720, 1280);
        }
            break;
        case H264VideoQuality_High2:
        {
            configuration.sessionPreset = H264CaptureSessionPreset720x1280;
            configuration.videoFrameRate = 20;
            configuration.videoBitRate = 1200 * 1000;
            configuration.videoMaxBitRate = 1440 * 1000;
            configuration.videoMinBitRate = 800 * 1000;
            configuration.videoSize = CGSizeMake(720, 1280);
        }
            break;
        case H264VideoQuality_High3:
        {
            configuration.sessionPreset = H264CaptureSessionPreset720x1280;
            configuration.videoFrameRate = 30;
            configuration.videoBitRate = 1200 * 1000;
            configuration.videoMaxBitRate = 1440 * 1000;
            configuration.videoMinBitRate = 500 * 1000;
            configuration.videoSize = CGSizeMake(720, 1280);
        }
            break;
        default:
            break;
    }
    configuration.videoProfileLevel =  (__bridge NSString *)(kVTProfileLevel_H264_Baseline_4_0);
    configuration.sessionPreset = [configuration supportSessionPreset:configuration.sessionPreset];
    configuration.videoMaxKeyframeInterval = configuration.videoFrameRate*3;
    return configuration;
}


#pragma mark -- private methods

/**
 切换视频分辨率
 
 @param sessionPreset 视频分辨率
 @return sessionPreset 当前视频分辨率
 */
- (H264VideoSessionPreset)supportSessionPreset:(H264VideoSessionPreset)sessionPreset
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *inputCamera;
    
    NSArray *devices = [self obtainAvailableDevices];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionFront)
        {
            inputCamera = device;
        }
    }
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([session canAddInput:videoInput])
    {
        [session addInput:videoInput];
    }
    
    if (![session canSetSessionPreset:self.avSessionPreset])
    {
        if (sessionPreset == H264CaptureSessionPreset720x1280)
        {
            sessionPreset = H264CaptureSessionPreset540x960;
            if (![session canSetSessionPreset:self.avSessionPreset])
            {
                sessionPreset = H264CaptureSessionPreset360x640;
            }
        } else if (sessionPreset == H264CaptureSessionPreset540x960)
        {
            sessionPreset = H264CaptureSessionPreset360x640;
        }
    }
    return sessionPreset;
}

//拿到所有可用的摄像头(video)设备
- (NSArray *)obtainAvailableDevices{
    
    if (@available(iOS 10.0, *)) {
        
        AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
        return deviceSession.devices;
    } else {
        // Fallback on earlier versions
        return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    }
}

/**
 画质枚举
 
 @return 视频分辨率（画质的清晰度）
 */
- (NSString *)avSessionPreset
{
    NSString *avSessionPreset = nil;
    switch (self.sessionPreset)
    {
        case H264CaptureSessionPreset360x640:
        {
            avSessionPreset = AVCaptureSessionPreset640x480;
        }
            break;
        case H264CaptureSessionPreset540x960:
        {
            avSessionPreset = AVCaptureSessionPresetiFrame960x540;
        }
            break;
        case H264CaptureSessionPreset720x1280:
        {
            avSessionPreset = AVCaptureSessionPreset1280x720;
        }
            break;
        default:
        {
            avSessionPreset = AVCaptureSessionPreset640x480;
        }
            break;
    }
    return avSessionPreset;
}


#pragma mark -- public setter
/**
 最大比特率
 
 @param videoMaxBitRate 最大比特率
 */
- (void)setVideoMaxBitRate:(NSUInteger)videoMaxBitRate
{
    if (videoMaxBitRate <= _videoBitRate) return;
    _videoMaxBitRate = videoMaxBitRate;
}

/**
 最小比特率
 
 @param videoMinBitRate 最小比特率
 */

- (void)setVideoMinBitRate:(NSUInteger)videoMinBitRate
{
    if (videoMinBitRate >= _videoBitRate) return;
    _videoMinBitRate = videoMinBitRate;
}

/**
 视频分辨率
 
 @param sessionPreset 视频分辨率
 */
- (void)setSessionPreset:(H264VideoSessionPreset)sessionPreset
{
    _sessionPreset = sessionPreset;
    _sessionPreset = [self supportSessionPreset:sessionPreset];
}

@end
