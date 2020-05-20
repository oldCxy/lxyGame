//
//  AudioConfigResultBase.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoSampleBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioRecordSampleBase : AudioVideoSampleBase

/**音频格式*/
@property (nonatomic,strong) NSNumber *audioFormat;
/**音频采样率*/
@property (nonatomic,strong) NSNumber *audioSampleRat;
/**音频的通道*/
@property (nonatomic,strong) NSNumber *audioChannels;
/**音频采样点位数*/
@property (nonatomic,strong) NSNumber *audioLinearPCMBit;
/**音频频格式是否是大端点*/
@property (nonatomic,strong) NSNumber *audioLinearPCMIsBigEndian;
/**音频格式是否使用浮点数采样*/
@property (nonatomic,strong) NSNumber *audioLinearPCMIsFloat;
/**设置录音质量:*/
@property (nonatomic,strong) NSNumber *audioQuality;
/** ... 其他设置*/


#pragma mark -- 音频的配置
- (NSDictionary *)setAudioConfigure;

@end

NS_ASSUME_NONNULL_END
