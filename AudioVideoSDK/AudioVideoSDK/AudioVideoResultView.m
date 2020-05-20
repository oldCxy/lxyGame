//
//  AudioVideoResultView.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoResultView.h"

@interface AudioVideoResultView ()

@property (nonatomic,strong) UIImageView *viewBg;//背景
@property (nonatomic,strong) MarkableProgressView *progressView;//录制进度

@end

@implementation AudioVideoResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self viewBg];
        [self progressView];
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
    
    self.viewBg.frame = self.bounds;
    self.progressView.frame = CGRectMake(0, 0, size.width, 10);
}

- (UIImageView *)viewBg{
    if (!_viewBg) {
        
        //背景
        _viewBg = [[UIImageView alloc]initWithFrame:self.bounds];
        _viewBg.image = [UIImage imageNamed:@"lyjbjt"];
        _viewBg.contentMode = UIViewContentModeScaleAspectFill ;
        _viewBg.layer.masksToBounds = YES;
        _viewBg.userInteractionEnabled = YES;
        [self addSubview:_viewBg];
    }
    return _viewBg;
}

- (MarkableProgressView *)progressView{
    if (!_progressView) {
        
        _progressView = [[MarkableProgressView alloc] initWithFrame:CGRectZero];
        [self addSubview:_progressView];
    }
    return _progressView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
