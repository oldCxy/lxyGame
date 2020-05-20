//
//  AudioVideoPlayerSampleBase.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/10.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 音视频播放的基础类
 */
@interface AudioVideoPlayerSampleBase : NSObject



/**
 是否在缓冲
 */
@property (nonatomic, assign) BOOL isBuffering;


/**
 播放声音的音量
 */
@property (nonatomic, assign) float volume;


/**
 当前播放器正在播放的url
 */
@property (nonatomic, strong, readonly) NSURL *currentURL;

/**
 视频音频长度
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 是否正在播放
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;




@end

NS_ASSUME_NONNULL_END
