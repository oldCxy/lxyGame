//
//  AudioRecordPlayView.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioRecordPlayView.h"

@interface AudioRecordPlayView ()


@end

@implementation AudioRecordPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self waveformProgressView];
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
    //CGSize size = self.bounds.size;
    self.waveformProgressView.center = self.center;
}

- (UIProgressView *)waveformProgressView{
    if (!_waveformProgressView) {
        
        _waveformProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
        _waveformProgressView.center = self.center;
        _waveformProgressView.progressTintColor = [UIColor redColor];
        _waveformProgressView.trackTintColor = [UIColor whiteColor];
        _waveformProgressView.progress = 0.0f;
        [self addSubview:_waveformProgressView];
    }
    return _waveformProgressView;
}

@end
