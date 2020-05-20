//
//  AudioVideoSampleBaseBottomView.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioVideoSampleBaseViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AudioVideoPlayButtonType) {
    AudioVideoPlayButtonAudioType,  //音频的播放按钮
    AudioVideoPlayButtonVideoType   //视频的播放按钮
};

@interface AudioVideoSampleBaseBottomView : UIView<AudioVideoSampleBaseViewProtocol>

@property (nonatomic,strong) id<AudioVideoSampleBaseViewProtocol> audioViewProtocol;

@property (nonatomic,assign) AudioVideoPlayButtonType playButtonType;

@property (nonatomic,assign) NSInteger currentClickIndex;//标记当前点击播放按钮的次数

@end

NS_ASSUME_NONNULL_END
