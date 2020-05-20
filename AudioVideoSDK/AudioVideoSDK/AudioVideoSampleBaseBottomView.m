//
//  AudioVideoSampleBaseBottomView.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoSampleBaseBottomView.h"

@interface AudioVideoSampleBaseBottomView ()

@property (nonatomic,strong) UIButton *playBtn;//录制暂停按钮
@property (nonatomic,strong) UILabel *recordTimeLab;//录制进度时间

@end

@implementation AudioVideoSampleBaseBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        _currentClickIndex = 0;
        [self playBtn];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat width = 50.0;
    CGFloat y = (size.height - width)/2.0;
    CGFloat x = (size.width - width)/2.0;
    self.playBtn.frame = CGRectMake(x , y, width, width);
}

- (void)setCurrentClickIndex:(NSInteger)currentClickIndex{
    _currentClickIndex = currentClickIndex;
    
    if (_playButtonType == AudioVideoPlayButtonAudioType) {//音频播放按钮
        
        switch (_currentClickIndex) {
            case 0:
                [_playBtn setImage:[UIImage imageNamed:@"lyj_lyan"] forState:UIControlStateNormal];
                break;
            case 1:
                [_playBtn setImage:[UIImage imageNamed:@"lyj_atan"] forState:UIControlStateNormal];
                break;
            default:
                [_playBtn setImage:[UIImage imageNamed:@"lyj_tian"] forState:UIControlStateNormal];
                break;
        }
    }else{//视频播放按钮
        
        switch (_currentClickIndex) {
            case 0:
                [_playBtn setImage:[UIImage imageNamed:@"lyj_lyan"] forState:UIControlStateNormal];
                break;
            default:
                [_playBtn setImage:[UIImage imageNamed:@"lyj_tian"] forState:UIControlStateNormal];
                break;
        }
    }
}

- (UIButton *)playBtn{
    if (!_playBtn) {

        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.center = self.center;
        [_playBtn setImage:[UIImage imageNamed:@"lyj_lyan"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
    }
    return _playBtn;
}


- (void)playAction:(UIButton *)button{
    
    self.currentClickIndex ++ ;
    button.tag = self.currentClickIndex + 100;
    
    //点击次数的最大边界,音频的为2，视频的为1
    NSInteger maxIndex = 2;
    if (_playButtonType == AudioVideoPlayButtonVideoType) maxIndex = 1;

    if (_currentClickIndex > maxIndex) {// 超过最大边界x，需重置播放按钮
        
        self.currentClickIndex = 0;
    }
    
    if ([self.audioViewProtocol respondsToSelector:@selector(didSelectedAudioVideoPlayBtn:)]) {
        [self.audioViewProtocol didSelectedAudioVideoPlayBtn:button];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
