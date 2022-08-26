//
//  BridgeQueue.m
//  BridgeQueue
//
//  Created by Meyun on 2022/8/23.
//
#import "BridgeQueue.h"

@interface BridgeQueue () {
  NSMutableArray<NSDictionary *>* _bridgeQueue;
}

@end

@implementation BridgeQueue


+ (nonnull instancetype)sharedInstance {
  static BridgeQueue* sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [self new];
  });
  
  return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.jsDidLoad = NO;
        _bridgeQueue = [NSMutableArray new];
    }

    return self;
}


- (void)postNotification:(NSNotification *)notification status:(NSString *)status {
    if (!_bridgeQueue) return;
    id obj = [[notification object] mutableCopy];
    [obj setValue:status forKey:@"status"];
    [_bridgeQueue insertObject:obj atIndex:0];
}


- (void)scheduleBridgeQueue {
    for (NSDictionary *notification in _bridgeQueue) {
        NSLog(@"%@", notification);
        NSString* status = [notification objectForKey:@"status"];
        if ([status isEqual: @"receive"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_GTPAYLOAD_NOTIFICATION object:notification];
        } else if ([status isEqual: @"open"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_CLICK_NOTIFICATION object:notification];
        }
    }
    [_bridgeQueue removeAllObjects];
}

@end
