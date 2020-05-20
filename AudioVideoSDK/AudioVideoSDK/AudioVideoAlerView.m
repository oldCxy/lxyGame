//
//  AudioVideoAlerView.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/6.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoAlerView.h"
#import "AudioVideoSettings.h"

#pragma mark - TuSDKICAlertAction
/**
 *  提示信息动作
 */
@interface AudioVideoAlertAction()
{
   AudioVideoAlertActionHandler _handler;
}
@end

@implementation AudioVideoAlertAction
/**
 *  提示信息动作 (默认)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return 提示信息动作
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title
                        handler:(AudioVideoAlertActionHandler)handler;
{
    return [self actionWithTitle:title style:AVAlertActionStyleDefault handler:handler];
}

/**
 *  提示信息动作 (取消)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return 提示信息动作
 */
+ (instancetype)actionCancelWithTitle:(nullable NSString *)title
                              handler:(AudioVideoAlertActionHandler)handler;
{
    return [self actionWithTitle:title style:AVAlertActionStyleCancel handler:handler];
}

/**
 *  提示信息动作 (强调)
 *
 *  @param title   标题
 *  @param handler 提示信息动作委托
 *
 *  @return 提示信息动作
 */
+ (instancetype)actionDestructiveWithTitle:(nullable NSString *)title
                                   handler:(AudioVideoAlertActionHandler)handler;
{
    return [self actionWithTitle:title style:AVAlertActionStyleDestructive handler:handler];
}

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(AVAlertActionStyle)style
                        handler:(AudioVideoAlertActionHandler)handler;
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(nullable NSString *)title
                        style:(AVAlertActionStyle)style
                      handler:(AudioVideoAlertActionHandler)handler;
{
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

/**
 *  执行动作
 */
- (void)handleAction;
{
    if (_handler) _handler(self);
}

/**
 *  获取UIAlertActionStyle
 *
 *  @return UIAlertActionStyle
 */
- (UIAlertActionStyle)uiAlertActionStyle;
{
    switch (self.style) {
        case AVAlertActionStyleCancel:
            return UIAlertActionStyleCancel;
        case AVAlertActionStyleDestructive:
            return UIAlertActionStyleDestructive;
        default:
            return UIAlertActionStyleDefault;
    }
}
@end

#pragma mark - TuSDKICAlertViewInstance
/**
 *  提示信息视图持久化实例(防止委托释放)
 */
@interface AudioVideoAlertViewInstance : NSObject
/**
 *  提示信息视图
 */
@property (nullable, nonatomic, retain) AudioVideoAlertView *alertView;
/**
 *  是否允许清除
 */
@property (nonatomic, assign) BOOL enableClear;

@end

@implementation AudioVideoAlertViewInstance
// 获取系统相册对象
+ (AudioVideoAlertViewInstance *)instance;
{
    static dispatch_once_t pred = 0;
    static AudioVideoAlertViewInstance *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[AudioVideoAlertViewInstance alloc] init];
    });
    return instance;
}

- (void)clear;
{
    if (self.enableClear) {
        self.alertView = nil;
    }
    _enableClear = !_enableClear;
}
@end
#pragma mark - TuSDKICAlertView
/**
 *  提示信息视图
 */
@interface AudioVideoAlertView()<UIActionSheetDelegate>
{
    /**
     *  动作列表
     */
    NSMutableArray<AudioVideoAlertAction *> *_actions;
}
/**
 *  启动视图控制器
 */
@property (nullable, nonatomic, assign) UIViewController *controller;
@end

@implementation AudioVideoAlertView

/**
 *  显示提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param message    信息
 */
+ (void)alertShowWithController:(nullable UIViewController *)controller
                        message:(nullable NSString *)message;
{
    [self alertShowWithController:controller title:nil message:message];
}

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
{
    [self alertShowWithController:controller title:title message:message cancelTitle:@"我知道了"];
}

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
{
    [self alertShowWithController:controller title:nil message:message cancelTitle:cancelTitle];
}


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
{
    AudioVideoAlertView *alert = [self alertWithController:controller title:title message:message];
    [alert addAction:[AudioVideoAlertAction actionCancelWithTitle:cancelTitle handler:nil]];
    [alert show];
}

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
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 8.0) {
        [self alertShowWithController:controller title:title message:message];
        return;
    }
    
    AudioVideoAlertView *alert = [self alertWithController:controller title:title message:message];
    [alert addAction:[AudioVideoAlertAction actionCancelWithTitle:@"取消" handler:nil]];
    // 开启设置界面
    [alert addAction:[AudioVideoAlertAction actionWithTitle:@"设置" handler:^(AudioVideoAlertAction * _Nonnull action) {
        [AudioVideoSettings OpenAppSettings];
    }]];
    [alert show];
}

/**
 *  提示信息视图 (对话框样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return 提示信息视图
 */
+ (instancetype)alertWithController:(nullable UIViewController *)controller
                              title:(nullable NSString *)title
                            message:(nullable NSString *)message;
{
    return [[self alloc]initWithController:controller title:title message:message preferredStyle:AVAlertStyleAlert];
}

/**
 *  提示信息视图 (下拉样式)
 *
 *  @param controller 控制器
 *  @param title      标题
 *  @param message    信息
 *
 *  @return 提示信息视图
 */
+ (instancetype)actionSheetWithController:(nullable UIViewController *)controller
                                    title:(nullable NSString *)title
                                  message:(nullable NSString *)message;
{
    return [[self alloc]initWithController:controller title:title message:message preferredStyle:AVAlertStyleActionSheet];
}

- (instancetype)initWithController:(nullable UIViewController *)controller
                             title:(nullable NSString *)title
                           message:(nullable NSString *)message
                    preferredStyle:(AVAlertStyle)preferredStyle;
{
    self = [super init];
    if (self) {
        _controller = controller;
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        _actions = [NSMutableArray<AudioVideoAlertAction *> array];
    }
    return self;
}

/**
 *  添加提示信息动作
 *
 *  @param action 提示信息动作
 */
- (void)addAction:(AudioVideoAlertAction *)action;
{
    if (!action) return;
    [_actions addObject:action];
}

/**
 *  显示提示信息视图
 */
- (void)show;
{
    switch (self.preferredStyle) {
        case AVAlertStyleActionSheet:
            [self showActionSheet];
            break;
        case AVAlertStyleAlert:
            [self showAlert];
            break;
        default:
            break;
    }
}

#pragma mark - showActionSheet
/**
 *  显示下拉菜单提示信息视图
 */
- (void)showActionSheet;
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 8.0) {
        [self showActionSheetView];
    }else{
        [self showAlertController];
    }
}
/**
 *  显示下拉菜单提示信息视图
 */
- (void)showActionSheetView;
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (AudioVideoAlertAction* action in self.actions) {
        NSInteger index = [actionSheet addButtonWithTitle:action.title];
        switch (action.style) {
            case AVAlertActionStyleCancel:
                actionSheet.cancelButtonIndex = index;
                break;
            case AVAlertActionStyleDestructive:
                actionSheet.destructiveButtonIndex = index;
                break;
            default:
                break;
        }
    }
    
    [AudioVideoAlertViewInstance instance].alertView = self;
    [AudioVideoAlertViewInstance instance].enableClear = ![AudioVideoAlertViewInstance instance].enableClear;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3);
{
    [self handleActionWithIndex:buttonIndex];
    [[AudioVideoAlertViewInstance instance] clear];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet NS_DEPRECATED_IOS(2_0, 8_3);
{
    [self handleCancelAction];
}
#pragma mark - showAlert
/**
 *  显示对话框提示信息视图
 */
- (void)showAlert;
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 8.0) {
        [self showAlertView];
    }else{
        [self showAlertController];
    }
}

/**
 *  显示对话框提示信息视图
 */
- (void)showAlertView;
{
    // 提示信息
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:self.title
                                                      message:self.message
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    
    for (AudioVideoAlertAction* action in self.actions) {
        NSInteger index = [alertView addButtonWithTitle:action.title];
        if (action.style == AVAlertActionStyleCancel) {
            alertView.cancelButtonIndex = index;
        }
    }
    [AudioVideoAlertViewInstance instance].alertView = self;
    [AudioVideoAlertViewInstance instance].enableClear = ![AudioVideoAlertViewInstance instance].enableClear;
    [alertView show];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    [self handleActionWithIndex:buttonIndex];
    [[AudioVideoAlertViewInstance instance] clear];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView NS_DEPRECATED_IOS(2_0, 9_0);
{
    [self handleCancelAction];
}

// 处理取消动作
- (void)handleCancelAction;
{
    for (AudioVideoAlertAction* action in self.actions) {
        if(action.style == AVAlertActionStyleCancel)
        {
            [action handleAction];
            break;
        }
    }
    
    [[AudioVideoAlertViewInstance instance] clear];
}

/**
 *  显示对话框提示信息视图控制器
 */
- (void)showAlertController;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title
                                                                             message:self.message
                                                                      preferredStyle:[self uiAlertControllerStyle]];

    for (AudioVideoAlertAction* action in self.actions) {
        UIAlertAction *uAction = [UIAlertAction actionWithTitle:action.title
                                                          style:[action uiAlertActionStyle]
                                                        handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [self handleActionWithIndex:[alertController.actions indexOfObject:action]];
                                  }];
        [alertController addAction:uAction];
    }
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

/**
 *  处理指定索引动作
 *
 *  @param index 索引
 */
- (void)handleActionWithIndex:(NSInteger)index;
{
    if(index > -1 && index < self.actions.count)
    {
        AudioVideoAlertAction* action = [self.actions objectAtIndex:index];
        [action handleAction];
    }
}

/**
 *  获取UIAlertControllerStyle
 *
 *  @return UIAlertControllerStyle
 */
- (UIAlertControllerStyle)uiAlertControllerStyle;
{
    switch (self.preferredStyle) {
        case AVAlertStyleActionSheet:
            return UIAlertControllerStyleActionSheet;
            
        default:
            return UIAlertControllerStyleAlert;
    }
}
@end
