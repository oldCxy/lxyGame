//
//  VideoH264EncorderInterface.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoH264Configuration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VideoH264EncoderDelegate <NSObject>

/**
 编码器编码后回调
 
 @param encoder 编码器
 @param frame 数据
 */
- (void)videoEncoder:(id<VideoH264EncoderDelegate>)encoder;
//- (void)videoEncoder:(id<TuSDKVideoEncoderInterface>)encoder videoFrame:(TuSDKVideoRTMPFrame *)frame;

@end


/**
 视频编码器的委托协议（约束）
 */
@protocol VideoH264EncoderInterface <NSObject>

@required
/**
 编码视频数据
 
 @param pixelBuffer 视频数据
 @param timeStamp 时间戳
 */
- (void)encodeVideoData:( CVPixelBufferRef)pixelBuffer timeStamp:(uint64_t)timeStamp;

/**
 码率
 */
@property (nonatomic, assign) NSInteger videoBitRate;

/**
 帧率
 */
@property (nonatomic, assign) NSInteger videoFrameRate;

/**
 初始化配置
 
 @param configuration 配置
 @return
 */
- ( instancetype)initWithVideoStreamConfiguration:(VideoH264Configuration *)configuration;

/**
 设置代理
 
 @param delegate 代理
 */
- (void)setDelegate:(id<VideoH264EncoderDelegate>)delegate;

/**
 停止编码
 */
- (void)stopEncoder;

@end

NS_ASSUME_NONNULL_END
