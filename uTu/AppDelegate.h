//
//  AppDelegate.h
//  uTu
//
//  Created by Sankar on 25/03/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFUser.h"
#import <GooglePlus/GooglePlus.h>
#import "InviteFriendsViewController.h"
#import "TwitterViewController.h"

@class GTMOAuth2Authentication;
@class DropDownDemoViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPDeepLinkDelegate,UIApplicationDelegate>{
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;
@property BOOL isRemoteNotificationEnabled;

@property (nonatomic, retain) NSString *device_token;

@property (nonatomic, strong) STTwitterAPI *twitter;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *rewardTimer;

@property(strong, nonatomic) UINavigationController *navigationController;
@property(strong, nonatomic) InviteFriendsViewController *inviteFriendsViewController;
@property(strong, nonatomic) TwitterViewController *twitterViewController;

@property (strong, nonatomic) UIView *profileView;

@property (nonatomic, strong) AFUser *user;

- (void)initTimer;

+ (AFUser *)user;
+ (STTwitterAPI *)twitter;
- (void) updateProfileImage;
+ (AppDelegate *)appDelegate;
- (void)recorderTimer;

@end
