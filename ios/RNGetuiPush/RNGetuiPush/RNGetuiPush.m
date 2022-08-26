//
//  RNGetuiPush.m
//  RNGetuiPush
//
//  Created by Meyun on 2022/8/23.
//

#import <React/RCTEventDispatcher.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#import <React/RCTLog.h>

#import "RNGetuiPush.h"


@implementation RNGetuiPush

RCT_EXPORT_MODULE(ReactNativeGetuiLatest)
@synthesize bridge = _bridge;
#pragma mark - 消息中心相关处理模块
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter removeObserver:self];
        
        [defaultCenter addObserver:self
                          selector:@selector(gtPayloadRemoteNotification:)
                              name:DID_RECEIVE_GTPAYLOAD_NOTIFICATION
                            object:nil];
      
        [defaultCenter addObserver:self
                        selector:@selector(clickNotification:)
                            name:DID_CLICK_NOTIFICATION
                          object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(jsDidLoad)
                              name:RCTJavaScriptDidLoadNotification
                            object:nil];
    }
    return self;
}
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
- (void)jsDidLoad {
    [BridgeQueue sharedInstance].jsDidLoad = YES;
    
    if ([BridgeQueue sharedInstance].openedRemoteNotification != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_CLICK_NOTIFICATION object:[BridgeQueue sharedInstance].openedRemoteNotification];
    }
    
    if ([BridgeQueue sharedInstance].openedLocalNotification != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_CLICK_NOTIFICATION object:[BridgeQueue sharedInstance].openedLocalNotification];
    }
    
    [[BridgeQueue sharedInstance] scheduleBridgeQueue];
}
- (void)setBridge:(RCTBridge *)bridge {
    _bridge = bridge;
    
    // 实现APP在关闭状态通过点击推送打开时的推送处理
    [BridgeQueue sharedInstance].openedRemoteNotification = [_bridge.launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [BridgeQueue sharedInstance].openedLocalNotification = [_bridge.launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
}
/**
 * @method 广播通知到达至RN端
 */
- (void)gtPayloadRemoteNotification:(NSNotification *)notification {
    id obj = [notification object];
    if ([BridgeQueue sharedInstance].jsDidLoad == YES) {
        [self.bridge.eventDispatcher sendAppEventWithName:@"receiveRemoteNotification"
                                                     body:obj];
    }else{
        [[BridgeQueue sharedInstance] postNotification:notification status:@"receive"];
    }
}

/**
 * @method 通知被点击
 */
- (void)clickNotification:(NSNotification *)notification {
    id obj = [notification object];
    // 如果js部分未加载完，则先存档
    if ([BridgeQueue sharedInstance].jsDidLoad == YES) {
        [self.bridge.eventDispatcher sendAppEventWithName:@"clickRemoteNotification"
                                                     body:obj];
    } else {
        [[BridgeQueue sharedInstance] postNotification:notification status:@"open"];
    }
}
#pragma mark - 导出供RN端调用方法
/**
 *  获取SDK的Cid
 *
 *  @return Cid值
 */
RCT_EXPORT_METHOD(clientId:(RCTResponseSenderBlock)callback)
{
    NSString *clientId = [GeTuiSdk clientId]?:@"";
    callback(@[clientId]);
}

/**
 *  获取SDK运行状态
 *
 *  @return 运行状态
 */
RCT_EXPORT_METHOD(isPushTurnedOn:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSString stringWithFormat:@"%lu",(unsigned long)[GeTuiSdk status]]]);
}

/**
 *  获取SDK版本号
 *
 *  @return 版本值
 */
RCT_EXPORT_METHOD(version:(RCTResponseSenderBlock)callback)
{
    callback(@[[GeTuiSdk version]]);
}

/**
 *  对齐android端方法
 */
RCT_EXPORT_METHOD(startSdk:(RCTResponseSenderBlock)callback)
{
    callback(@[@YES]);
}
@end
