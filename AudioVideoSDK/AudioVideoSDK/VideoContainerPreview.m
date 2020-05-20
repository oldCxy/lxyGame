//
//  VideoContainerPreview.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/14.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "VideoContainerPreview.h"
#import "HWVideoProgress.h"

@interface VideoContainerPreview ()

@property (nonatomic, weak) UIView *containerView;//录制视频容器
@property (nonatomic, weak) UIView *playContainerView;//播放视频容器
@property (nonatomic, weak) UIView *previewView;//预览视图
@property (nonatomic, weak) UIImageView *focusCursor;//聚焦按钮

@property (nonatomic, weak) UIButton *playBtn;//播放/暂停按钮
@property (nonatomic, weak) UIButton *finishBtn;//完成按钮
@property (nonatomic, weak) UIButton *cameraSwitchBtn;//摄像头切换按钮

@property (nonatomic, weak) UILabel *currentLabel;//预览视图当前时长
@property (nonatomic, weak) UILabel *totalLabel;//预览视图总时长
@property (nonatomic, weak) UILabel *recLabel;//REC标签
@property (nonatomic, weak) UILabel *recordTimeLabel;//录制视频时长标签

@property (nonatomic, weak) HWVideoProgress *progress;//播放进度

@end

@implementation VideoContainerPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark -- 懒加载创建控件
- (void)creatControl
{
    CGFloat btnW = 150.f;
    CGFloat btnH = 40.f;
    CGFloat marginY = 20.f;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    //内容视图
    CGFloat containerViewH = h - 64 - btnH - marginY * 3;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 64 + marginY, w - 20, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 1.f;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview:containerView];
    _containerView = containerView;
    
    //聚焦图片
    UIImageView *focusCursor = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 75, 75)];
    focusCursor.alpha = 0;
    focusCursor.image = [UIImage imageNamed:@"camera_focus_red"];
    [containerView addSubview:focusCursor];
    _focusCursor = focusCursor;
    
    //摄像头切换按钮
    CGFloat cameraSwitchBtnW = 50.f;
    CGFloat cameraSwitchBtnMargin = 10.f;
    UIButton *cameraSwitchBtn = [[UIButton alloc] initWithFrame:CGRectMake(containerView.bounds.size.width - cameraSwitchBtnW - cameraSwitchBtnMargin * 2, cameraSwitchBtnMargin, cameraSwitchBtnW, cameraSwitchBtnW)];
    [cameraSwitchBtn setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
    [cameraSwitchBtn addTarget:self action:@selector(cameraSwitchBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cameraSwitchBtn];
    _cameraSwitchBtn = cameraSwitchBtn;
    
    //REC
    UILabel *recLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 60, 40)];
    recLabel.text = @"REC";
    recLabel.font = [UIFont boldSystemFontOfSize:20.f];
    recLabel.textColor = [UIColor redColor];
    [containerView addSubview:recLabel];
    _recLabel = recLabel;
    
    //录制时间
    UILabel *recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recLabel.frame), CGRectGetMinY(recLabel.frame), 150, 40)];
    recordTimeLabel.text = @"00:00";
    recordTimeLabel.textColor = [UIColor whiteColor];
    recordTimeLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [containerView addSubview:recordTimeLabel];
    _recordTimeLabel = recordTimeLabel;
    
    //播放器容器
    UIView *playContainerView = [[UIView alloc] initWithFrame:containerView.frame];
    playContainerView.hidden = YES;
    playContainerView.layer.borderWidth = 1.f;
    playContainerView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview:playContainerView];
    _playContainerView = playContainerView;
    
    //预览控制面板
    UIView *previewView = [[UIView alloc] initWithFrame:containerView.frame];
    previewView.hidden = YES;
    [self addSubview:previewView];
    _previewView = previewView;
    
    //黑色透明底
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, previewView.bounds.size.height - 40, previewView.bounds.size.width, 40)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [previewView addSubview:backView];
    
    //播放开始、停止按钮
    CGFloat playBtnH = 40.f;
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, playContainerView.bounds.size.height - playBtnH, playBtnH, playBtnH)];
    [playBtn setImage:[UIImage imageNamed:@"video_recordBtn_nor"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"video_recordBtn_sel"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [previewView addSubview:playBtn];
    _playBtn = playBtn;
    
    //播放时长
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playBtn.frame) + 10, CGRectGetMinY(playBtn.frame), 56, playBtnH)];
    currentLabel.text = @"00:00";
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [previewView addSubview:currentLabel];
    _currentLabel = currentLabel;
    
    //播放进度
    CGFloat progressH = 5.f;
    CGFloat progressW = previewView.bounds.size.width - 8 - playBtnH - (56 + 10) * 2 - 20;
    HWVideoProgress *progress = [[HWVideoProgress alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentLabel.frame), CGRectGetMinY(playBtn.frame) + playBtnH * 0.5 - progressH * 0.5, progressW, progressH)];
    [previewView addSubview:progress];
    _progress = progress;
    
    //总时长
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progress.frame) + 10, CGRectGetMinY(playBtn.frame), 56, playBtnH)];
    totalLabel.text = @"00:00";
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [previewView addSubview:totalLabel];
    _totalLabel = totalLabel;
    
    //按钮
    NSArray *titleArray = @[@"录制视频", @"预览视频"];
    CGFloat btnY = CGRectGetMaxY(containerView.frame) + marginY;
    CGFloat margin = (w - btnW * titleArray.count) / (titleArray.count + 1);
    for (int i = 0; i < titleArray.count; i++) {
        CGFloat btnX = margin + (margin + btnW) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = 1000 + i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = 2.0f;
        btn.layer.masksToBounds = YES;
        if (i == 1) {
            btn.hidden = YES;
        }
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

//#pragma mark -- Action
//- (void)btnOnClick:(UIButton *)btn
//{
//    btn.enabled = NO;
//    if (btn.tag == 1000) {
//        if (self.captureMovieFileOutput.isRecording) {
//            //重新录制
//            [self finishBtnOnClick];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self startRecordVideo];
//            });
//        }else {
//            //开始录制
//            [self startRecordVideo];
//        }
//
//    }else if (btn.tag == 1001) {
//        if ([btn.titleLabel.text isEqualToString:@"完成录制"]) {
//            //完成录制
//            [self finishBtnOnClick];
//        }else {
//            //预览视频
//            [self reviewBtnOnClick];
//        }
//    }
//
//    btn.enabled = YES;
//}

@end
