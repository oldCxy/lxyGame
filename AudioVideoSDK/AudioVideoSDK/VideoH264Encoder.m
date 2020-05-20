//
//  VideoH264Encoder.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "VideoH264Encoder.h"

@interface VideoH264Encoder ()
{
    /**编码会话*/
    VTCompressionSessionRef compressionSession;
    NSInteger frameCount;
    NSData *sps;
    NSData *pps;
    FILE *fp;
    BOOL enabledWriteVideoFile;
}

/**
 视频配置项
 */
@property (nonatomic, strong) VideoH264Configuration *configuration;

/**
 代理
 */
@property (nonatomic, weak) id<VideoH264EncoderDelegate> h264Delegate;

/**
 进入后台
 */
@property (nonatomic) BOOL isBackGround;

@end

@implementation VideoH264Encoder

- (void)dealloc{
    
    [self destoryCompressionSession];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _encodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _outputFileName = @"h264";
        _saveSuffixFormat = @".h264";
        
        [self addNotifaction];
    }
    return self;
}

- (instancetype)initWithVideoStreamConfiguration:(VideoH264Configuration *)configuration{
    if (self = [super init]) {
        
        _configuration = configuration;
        [self initCompressionSession];
    }
    return self;
}

#pragma mark -- private methods

/**
 添加进入后台/前台的通知
 */
- (void)addNotifaction{
    
    // app进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
/**
 销毁编码会话
 */
- (void)destoryCompressionSession{
    
    if (compressionSession) {
        
        //编码完成使其编码器无效，跳出编码会话
        VTCompressionSessionCompleteFrames(compressionSession, kCMTimeInvalid);
        
        //结束压缩编码会话（使其无效）。
        VTCompressionSessionInvalidate(compressionSession);
        //释放编码会话
        CFRelease(compressionSession);
        compressionSession = nil;
    }
}

/**
 初始化编码会话的配置
 */
- (void)initCompressionSession{
    
    [self destoryCompressionSession];
    
    // 1.创建VTCompressionSessionRef
    // 1> 参数一: CFAllocatorRef用于CoreFoundation分配内存的模式 NULL使用默认的分配方式
    // 2> 参数二: 编码出来视频的宽度 width
    // 3> 参数三: 编码出来视频的高度 height
    // 4> 参数四: 编码的标准 : H.264/AVC
    // 5> 参数五/六/七 : NULL
    // 6> 参数八: 编码成功后的回调函数
    // 7> 参数九: 可以传递到回调函数中参数, self : 将当前对象传入
    OSStatus status = VTCompressionSessionCreate(NULL, _configuration.videoSize.width, _configuration.videoSize.height, kCMVideoCodecType_H264, NULL, NULL, NULL, VideoCompressonOutputCallback, (__bridge void *)self, &compressionSession);
    
    //编码会话创建错误，自动跳出
    if (status != noErr)  return;
    
    // 2.在VideoToolbox编码会话上设置属性
    // 2.1.设置实时输出
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    // 2.2.设置帧率
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_ExpectedFrameRate, (__bridge CFTypeRef _Nonnull)@(_configuration.videoFrameRate));
    // 2.3.设置比特率(码率) 1500000/s
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef _Nonnull)@(_configuration.videoBitRate)); // bit
    // 2.4. 0、1或2个数据速率的硬限制。
    NSArray *limit = @[@(_configuration.videoBitRate * 1.2), @(1)];
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_DataRateLimits, (__bridge CFTypeRef _Nonnull)limit); // byte
    // 2.5.设置GOP的大小,关键帧之间的最大间隔，也称为关键帧速率。
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, (__bridge CFTypeRef)@(_configuration.videoMaxKeyframeInterval));
    // 2.6.从一个关键帧到下一个关键帧的最大持续时间(以秒为单位)。
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration, (__bridge CFTypeRef)@(_configuration.videoMaxKeyframeInterval));
    // 2.7. 已编码位流的概要文件和级别。
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_ProfileLevel, (__bridge CFTypeRef)(_configuration.videoProfileLevel));
    // 2.8. 一个布尔值，指示是否启用帧重排序。
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanTrue);
    // 2.9. H.264压缩的熵编码模式。
    VTSessionSetProperty(compressionSession, kVTCompressionPropertyKey_H264EntropyMode, kVTH264EntropyMode_CABAC);

    // 3.准备编码
    VTCompressionSessionPrepareToEncodeFrames(compressionSession);
}

/**
 设置代理
 
 @param delegate 代理
 */
- (void)setDelegate:(id<VideoH264EncoderDelegate>)delegate
{
    _h264Delegate = delegate;
}

#pragma mark -- publice methods
/**
 停止编码
 */
- (void)stopEncoder
{
    VTCompressionSessionCompleteFrames(compressionSession, kCMTimeIndefinite);
}

#pragma mark - NSNotification

/**
 进入后台
 
 @param notification 消息
 */
- (void)willEnterBackground:(NSNotification *)notification
{
    _isBackGround = YES;
}

/**
 进入前台
 
 @param notification 消息
 */
- (void)willEnterForeground:(NSNotification *)notification
{
    [self initCompressionSession];
    _isBackGround = NO;
}

#pragma mark - VideoCallBack

/**
 通过硬编码回调获取h264数据
 
 @param VTref 获取H264Encoder的对象指针
 @param VTFrameRef 时间戳
 @param status 状态
 @param infoFlags 编码信息状态
 @param sampleBuffer 编码后的数据包
 */
static void VideoCompressonOutputCallback(void *VTref, void *VTFrameRef, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer)
{
    
    
}
@end
