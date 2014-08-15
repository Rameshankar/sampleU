//
//  ReachabilityManager.h
//  Ola Mundo
//
//  Created by Satyen Vats on 8/24/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

@class Reachability;

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
