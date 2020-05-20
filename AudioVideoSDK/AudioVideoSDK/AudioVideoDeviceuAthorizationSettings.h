//
//  AudioVideoDeviceuAthorizationSettings.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/6.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoDeviceSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  设备权限设置类型
 */
typedef NS_ENUM(NSInteger, AVDeviceSettingsType)
{
    /**
     *  未知类型
     */
    AVDeviceSettingsUnknow,
    /**
     *  设置照片权限
     */
    AVDeviceSettingsPhoto,
    /**
     * 设置相机权限
     */
    AVDeviceSettingsCamera,
    /**
     * 设置定位权限
     */
    AVDeviceSettingsLocation,
    /**
     *  设置照片权限
     */
    AVDeviceSettingsMicrophone,
    /**其他权限设置*/
};

/**
 *  设备权限设置
 *
 *  @param type        设备权限设置类型
 *  @param openSetting 是否开启权限设置
 */
typedef void (^AVSDKTSDeviceSettingsBlock)(AVDeviceSettingsType type, BOOL openSetting);

@interface AudioVideoDeviceuAthorizationSettings : AudioVideoDeviceSettings


/**
 *  检查设备权限
 *
 *  @param controller UIViewController
 *  @param type       设备权限设置类型
 *  @param completed  设备权限设置
 */
+ (void)checkAllowWithController:(UIViewController *)controller type:(AVDeviceSettingsType)type completed:(AVSDKTSDeviceSettingsBlock)completed;

@end

NS_ASSUME_NONNULL_END
