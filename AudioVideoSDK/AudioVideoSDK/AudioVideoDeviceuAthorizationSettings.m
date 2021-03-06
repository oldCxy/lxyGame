//
//  AudioVideoDeviceuAthorizationSettings.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/6.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoDeviceuAthorizationSettings.h"
#import <CoreLocation/CoreLocation.h>

#import "AudioVideoAlerView.h"

/**
 *  设备权限设置
 */
@interface AudioVideoDeviceuAthorizationSettings(){
    
}

// 设备权限设置处理结果
@property (nonatomic,strong) AVSDKTSDeviceSettingsBlock completed;

// 设备权限设置类型
@property (nonatomic,assign) AVDeviceSettingsType type;

// 控制器
@property (nonatomic, assign) UIViewController *controller;

@end

@implementation AudioVideoDeviceuAthorizationSettings

+ (instancetype)shared;
{
    static dispatch_once_t pred = 0;
    static AudioVideoDeviceuAthorizationSettings *object = nil;
    dispatch_once(&pred, ^{
        object = [[self alloc]init];
    });
    return object;
}
/**
 *  检查设备权限
 *
 *  @param controller UIViewController
 *  @param type       设备权限设置类型
 *  @param completed  设备权限设置
 */
+ (void)checkAllowWithController:(UIViewController *)controller type:(AVDeviceSettingsType)type completed:(AVSDKTSDeviceSettingsBlock)completed;
{
    AudioVideoDeviceuAthorizationSettings *obj = [self shared];
    obj.completed = completed;
    obj.controller = controller;
    [obj checkAllowType:type];
}

- (void)checkAllowType:(AVDeviceSettingsType)type;
{

    self.type = type;
    switch (type) {
        case AVDeviceSettingsPhoto:
            [self handleSettingsPhoto];
            break;
        case AVDeviceSettingsCamera:
            [self handleSettingsCamera];
            break;
        case AVDeviceSettingsLocation:
            [self handleSettingsLocation];
            break;
        case AVDeviceSettingsMicrophone:
            [self handleSettingsMicrophone];
            break;
        default:
            break;
    }
}

//设置照片权限
- (void)handleSettingsPhoto;
{

    // 已授权
    if ([AudioVideoDeviceSettings hasAuthor] ||
        ([[[UIDevice currentDevice] systemVersion] intValue] < 8.0 && [AudioVideoDeviceSettings notDetermined]) ) {
        [self notifyResult:NO];
        return;
    }
    
    // 未设置授权状态，弹出权限验证窗口
    if ([AudioVideoDeviceSettings notDetermined])
    {
        [AudioVideoDeviceSettings testLibraryAuthor:^(NSError *error)
         {
             if (error)
             {
                 [self showPhotosDisableMessage];
             }
             else
             {
                 [self notifyResult:NO];
             }
         }];
        return;
    }

    [self showPhotosDisableMessage];
}

// 提示设置照片权限对话框
- (void)showPhotosDisableMessage;
{
    NSString *msg = [NSString stringWithFormat: @"无法访问相册.请在'设置->隐私->照片'设置 %@ 为打开状态", [AudioVideoSettings getAppName]];
    NSString *title = @"无法访问相册";
    
    [self showSettingDisableMessage: msg title:title];
}


// 设置相机权限
- (void)handleSettingsCamera;
{
    if ([AudioVideoDeviceSettings hasVideoAuthor])
    {
        [self notifyResult:NO];
        return;
    }
    
    NSString *msg = nil;
    
    if ([AudioVideoDeviceSettings getCameraCounts] == 0 || ![AudioVideoDeviceSettings getBackOrFrontCamera]) {
        msg = @"您的设备没有相机功能！";
    }else{
        msg = [NSString stringWithFormat: @"无法访问系统相机.请在'设置->隐私->相机'设置 %@ 为打开状态", [AudioVideoSettings getAppName]];
    }
    
    NSString *title = @"无法访问系统相机";
    
    [self showSettingDisableMessage: msg title:title];
}

// 设置定位权限
- (void)handleSettingsLocation;
{
    // 已授权，或未设置授权状态不进行处理
    if (!(![CLLocationManager locationServicesEnabled]
          || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied
          || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted))
    {
        [self notifyResult:NO];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"无法获取地理信息.请在'设置->隐私->定位服务'设置 定位服务以及 %@ 为打开状态", [AudioVideoSettings getAppName]];
    NSString *title = @"无法获取地理信息";
    
    [self showSettingDisableMessage: msg title:title];
}
//设置麦克风权限
- (void)handleSettingsMicrophone;
{

    if ([AudioVideoDeviceSettings haseMicrophoneAuthor])
    {
        [self notifyResult:NO];
        return;
    }
    NSString *msg = [NSString stringWithFormat: @"无法访问系统麦克风.请在'设置->隐私->相机'设置 %@ 为打开状态", [AudioVideoSettings getAppName]];
    NSString *title = @"无法获取系统麦克风";
    
    [self showSettingDisableMessage: msg title:title];
}
// 显示设置被禁用信息
- (void)showSettingDisableMessage:(NSString *)msg title:(NSString *)title;
{
    [AudioVideoAlertView alertShowConfigWithController:self.controller title:title message:msg];
    [self notifyResult:YES];
}

// 通知结果
- (void)notifyResult:(BOOL)openSetting;
{
    if (self.completed) {
        self.completed(self.type, openSetting);
    }
    self.completed = nil;
    self.controller = nil;
    self.type = AVDeviceSettingsUnknow;
}

@end
