//
//  AudioVideoAlerView.h
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/6.
//  Copyright © 2019 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  提示信息动作样式
 */
typedef NS_ENUM(NSInteger, AVAlertActionStyle){
    /**
     *  默认
     */
    AVAlertActionStyleDefault = 0,
    /**
     *  取消
     */
    AVAlertActionStyleCancel,
    /**
     *  强调
     */
    AVAlertActionStyleDestructive
};

/**
 *  提示信息样式
 */
typedef NS_ENUM(NSInteger, AVAlertStyle){
    /**
     *  下拉样式
     */
    AVAlertStyleActionSheet = 0,
    /**
     *  对话框样式
     */
    AVAlertStyleAlert
};

#pragma mark - TuSDKICAlertAction
@class AudioVideoAlertAction;

/**
 *  提示信息动作委托
 *
 *  @param action 提示信息动作
 */
typedef void(^AudioVideoAlertActionHandler)(AudioVideoAlertAction *action);
/**
 *  提示信息动作
 */
@interface AudioVideoAlertAction : NSObject
/**
 *  提示信息动作 (默认)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title
                        handler:(nullable AudioVideoAlertActionHandler)handler;

/**
 *  提示信息动作 (取消)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionCancelWithTitle:(nullable NSString *)title
                              handler:(nullable AudioVideoAlertActionHandler)handler;

/**
 *  提示信息动作 (强调)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionDestructiveWithTitle:(nullable NSString *)title
                                   handler:(nullable AudioVideoAlertActionHandler)handler;

/**
 *  提示信息动作
 *
 *  @param title   标题
 *  @param style   提示信息动作样式
 *  @param handler 提示信息动作委托
 *
 *  @return action 提示信息动作
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(AVAlertActionStyle)style
                        handler:(nullable AudioVideoAlertActionHandler)handler;

/**
 *  标题
 */
@property (nullable, nonatomic, readonly) NSString *title;
/**
 *  提示信息动作样式
 */
@property (nonatomic, readonly) AVAlertActionStyle style;
@end


#pragma mark - TuSDKICAlertView
/**
 *  提示信息视图
 */
@interface AudioVideoAlertView : NSObject

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param message    信息
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                        message:(nullable NSString *)message;

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                          title:(nullable NSString *)title
                        message:(nullable NSString *)message;

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller  控制器
 *  @param message     信息
 *  @param cancelTitle 取消按钮文字
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                        message:(nullable NSString *)message
                    cancelTitle:(nullable NSString *)cancelTitle;


/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller  控制器
 *  @param title       标题
 *  @param message     信息
 *  @param cancelTitle 取消按钮文字
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                          title:(nullable NSString *)title
                        message:(nullable NSString *)message
                    cancelTitle:(nullable NSString *)cancelTitle;

/**
 *  显示提示信息视图 (对话框样式，大于等于IOS7时显示系统设置按钮)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 */
+ (void)alertShowConfigWithController:(nullable UIViewController *)controller
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message;

/**
 *  提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return message 提示信息视图
 */
+ (instancetype)alertWithController:(nullable UIViewController *)controller
                              title:(nullable NSString *)title
                            message:(nullable NSString *)message;

/**
 *  提示信息视图 (下拉样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return message 提示信息视图
 */
+ (instancetype)actionSheetWithController:(nullable UIViewController *)controller
                                    title:(nullable NSString *)title
                                  message:(nullable NSString *)message;

/**
 *  添加提示信息动作
 *
 *  @param action 提示信息动作
 */
- (void)addAction:(AudioVideoAlertAction *)action;

/**
 *  显示提示信息视图
 */
- (void)show;

/**
 *  提示信息动作列表
 */
@property (nonatomic, readonly) NSArray<AudioVideoAlertAction *> *actions;
/**
 *  标题
 */
@property (nullable, nonatomic, copy) NSString *title;
/**
 *  信息
 */
@property (nullable, nonatomic, copy) NSString *message;

/**
 *  提示信息样式
 */
@property (nonatomic, readonly) AVAlertStyle preferredStyle;


@end

NS_ASSUME_NONNULL_END
