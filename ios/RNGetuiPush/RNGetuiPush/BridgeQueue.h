//
//  BridgeQueue.h
//  BridgeQueue
//
//  Created by Meyun on 2022/8/23.
//
#import <Foundation/Foundation.h>
#import "RNGetuiPush.h"

@interface BridgeQueue : NSObject
333
@property BOOL jsDidLoad;
@property NSDictionary* openedRemoteNotification;
@property NSDictionary* openedLocalNotification;

+ (nonnull instancetype)sharedInstance;

- (void)postNotification:(NSNotification *)notification status:(NSString *)status;
- (void)scheduleBridgeQueue;

@end
