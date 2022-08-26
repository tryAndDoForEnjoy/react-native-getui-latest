//
//  RNGetuiPush.h
//  RNGetuiPush
//
//  Created by Meyun on 2022/8/23.
//
#import <Foundation/Foundation.h>
#import "BridgeQueue.h"


#import <React/RCTBridgeModule.h>
#import <GTSDK/GeTuiSdk.h> 

// 消息中心事件定义
#define DID_RECEIVE_GTPAYLOAD_NOTIFICATION  @"didReceiveGtPayloadNotification"    // 接收到Getui消息
#define DID_CLICK_NOTIFICATION @"didClickNotification"   // 通知栏被点击


@interface RNGetuiPush : NSObject <RCTBridgeModule>

@end
