//
//  VideoH264Encoder.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoEncodeSampleBase.h"
#import "VideoH264EncoderInterface.h"

NS_ASSUME_NONNULL_BEGIN

/**
 硬编码：视频编码器
 */
@interface VideoH264Encoder : AudioVideoEncodeSampleBase<VideoH264EncoderInterface>


+ (instancetype)encoder;

@end



NS_ASSUME_NONNULL_END
