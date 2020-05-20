//
//  AudioVideoSampleBaseViewProtocol.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioVideoSampleBaseViewProtocol <NSObject>

@optional

#pragma mark -- 音视频共有
/**播放按钮的点击事件*/
- (void)didSelectedAudioVideoPlayBtn:(UIButton *)btn;

@end

NS_ASSUME_NONNULL_END
