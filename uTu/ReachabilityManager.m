//
//  ReachabilityManager.m
//  Ola Mundo
//
//  Created by Satyen Vats on 8/24/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "Reachability.h"
#import "ReachabilityManager.h"

@implementation ReachabilityManager

#pragma mark Default Manager
+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark Private Initialization
- (id)init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        [self.reachability startNotifier];
    }
    return self;
}

#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isUnreachable {
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isReachableViaWWAN {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}
+ (BOOL)isReachableViaWiFi {
    return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark Memory Management
- (void)dealloc {
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

@end