//
//  AudioVideoEncodeSampleBase.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/20.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoSampleBase.h"
#import <AudioToolbox/AudioToolbox.h>
#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioVideoEncodeSampleBase : AudioVideoSampleBase
{
    /**编码线程*/
    dispatch_queue_t _encodeQueue;
    /**记录当前的帧数*/
    NSInteger _frameID;
//    /** 文件写入对象 */
//    NSFileHandle *_fileHandle;
}

@end

NS_ASSUME_NONNULL_END
