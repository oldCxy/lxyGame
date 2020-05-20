//
//  AudioVideoPlayer.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/11.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoPlayerSampleBase.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AudioVideoPlayerState) {
    AudioVideoPlayerStateReadyToPlay, // 播放器准备完毕
    AudioVideoPlayerStatePlaying, // 正在播放
    AudioVideoPlayerStatePause, // 暂停
    AudioVideoPlayerStateStop, // 播放完毕
    AudioVideoPlayerStateBufferEmpty, // 缓冲中
    AudioVideoPlayerStateKeepUp, // 缓冲完成
    AudioVideoPlayerStateFailed, // 播放器准备失败、网络原因，格式原因
    AudioVideoPlayerStateUnKnow // 播放器准备失败，发生未知原因
};

@class AudioVideoPlayer;

@protocol AudioVideoPlayerDelegate <NSObject>
@optional
/**
 播放器状态变化
 @param state 状态
 @param player 播放器
 */
- (void)AudioVideoPlayerStateChange:(AudioVideoPlayerState)state player:(AudioVideoPlayer *)player;

/**
 视频源开始加载后调用 ，返回视频的长度
 @param time 长度（秒）
 @param player 播放器
 */
- (void)AudioVideoPlayerTotalTime:(CGFloat)time player:(AudioVideoPlayer *)player;

/**
 视频源加载时调用 ，返回视频的缓冲长度
 @param time 长度（秒）
 @param player 播放器
 */
- (void)AudioVideoPlayerLoadTime:(CGFloat)time player:(AudioVideoPlayer *)player;

/**
 播放时调用，返回当前时间
 @param time 播放到当前的时间（秒）
 @param player 播放器
 */
- (void)AudioVideoPlayerCurrentTime:(CGFloat)time player:(AudioVideoPlayer *)player;

@end

@interface AudioVideoPlayer : AudioVideoPlayerSampleBase

//音视频播放器
@property (nonatomic,strong) AVPlayer *player;

//音频播放器：只能播放本地音频资源
//@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

//音视频播放器的资源管理类
@property (nonatomic,strong) AVPlayerItem *playerItem;

//视频预览层
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

/** 播放器预览层的背景色 */
@property (nonatomic,strong) UIColor *playerLayerBackColor;

/** 代理 */
@property (nonatomic, weak) id<AudioVideoPlayerDelegate> delegate;

/** 使用播放源进行初始化 */
- (instancetype)initWithUrl:(NSString *)url;

/** 播放 */
- (void)play;
/** 暂停 */
- (void)pause;
/** 停止 */
- (void)stop;


@end

NS_ASSUME_NONNULL_END
