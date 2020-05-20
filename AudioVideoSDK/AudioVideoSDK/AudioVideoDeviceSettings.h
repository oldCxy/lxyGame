//
//  AudioVideoDeviceSettings.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/6.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoSettings.h"


NS_ASSUME_NONNULL_BEGIN
/**
 *  系统相册授权错误
 */
typedef NS_ENUM(NSInteger, AVAssetsAuthorizationError){
    /**
     *  未定义
     */
    AVAssetsAuthorizationErrorNotDetermined = 0,
    /**
     *  限制访问
     */
    AVAssetsAuthorizationErrorRestricted,
    /**
     *  拒绝访问
     */
    AVAssetsAuthorizationErrorDenied
};

/**
 *  系统相册授权回调
 *
 *  @param error 是否返回错误信息
 */
typedef void (^AVSDKTSAssetsManagerAuthorBlock)(NSError *error);

/**
 *  系统相册授权回调
 *
 *  @param error 是否返回错误信息
 */
typedef void (^ALAssetsLibraryAuthorBlock)(NSError *error);

@interface AudioVideoDeviceSettings : AudioVideoSettings

#pragma mark - Camera
/**
 *  测试系统摄像头授权状态
 *
 *  @return    返回是否授权
 */
+ (BOOL)hasVideoAuthor;

/**
 *  相机设备总数
 *
 *  @return 相机设备总数
 */
+ (int)getCameraCounts;

/**
 *  获取相机设备（前置或后置） 后置优先
 *
 *  @return 相机设备
 */
+ (AVCaptureDevice *)getBackOrFrontCamera;


#pragma mark - Photo
/**
 *  是否用户已授权访问系统相册
 *
 *  @return 是否用户已授权访问系统相册
 */
+ (BOOL)hasAuthor;
/**
 *  是否未决定授权
 *
 *  @return 是否未决定授权
 */
+ (BOOL)notDetermined;

/**
 *  低版本小于8.0测试系统相册授权状态
 *
 *  @param authorBlock 系统相册授权回调
 */
+ (void)lowVersionTestLibraryAuthor:(AVSDKTSAssetsManagerAuthorBlock)authorBlock;

/**
 *  测试系统相册授权状态
 *
 *  @param authorBlock 系统相册授权回调
 */
+ (void)testLibraryAuthor:(AVSDKTSAssetsManagerAuthorBlock)authorBlock;

#pragma mark - Microphone
/**
 *  是否用户已授权访问系统麦克风
 *
 *  @return 是否用户已授权访问系统麦克风
 */
+ (BOOL)haseMicrophoneAuthor;
@end

NS_ASSUME_NONNULL_END
