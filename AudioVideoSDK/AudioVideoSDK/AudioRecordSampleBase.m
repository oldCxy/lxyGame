//
//  AudioConfigResultBase.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioRecordSampleBase.h"


@implementation AudioRecordSampleBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.outputFileName = @"audioFile";
        self.saveSuffixFormat = @"caf";
        
        _audioFormat = @(kAudioFormatLinearPCM);
        _audioSampleRat = @8000;
        _audioChannels = @1;
        _audioLinearPCMBit = @8;
        _audioLinearPCMIsFloat = @(NO);
        _audioLinearPCMIsBigEndian = @(NO);
        _audioQuality = @(AVAudioQualityMedium);
    }
    return self;
}



#pragma mark -- 音频的配置
- (NSDictionary *)setAudioConfigure{

    //(2)设置录音的音频参数
    /*
     1 ID号:acc
     2 采样率(HZ):每秒从连续的信号中提取并组成离散信号的采样个数
     3 通道的个数:(1 单声道 2 立体声)
     4 采样位数(8 16 24 32) 衡量声音波动变化的参数
     5 大端或者小端 (内存的组织方式)
     6 采集信号是整数还是浮点数
     7 音频编码质量
     */
    NSDictionary *configure = @{
                           AVFormatIDKey:_audioFormat,//音频格式
                           AVSampleRateKey:_audioSampleRat,//采样率
                           AVNumberOfChannelsKey:_audioChannels,//声道数
                           AVLinearPCMBitDepthKey:_audioLinearPCMBit,//采样位数
                           AVLinearPCMIsBigEndianKey:_audioLinearPCMIsBigEndian,
                           AVLinearPCMIsFloatKey:_audioLinearPCMIsFloat,
                           AVEncoderAudioQualityKey:_audioQuality,
                           };
    return configure;
}




@end
