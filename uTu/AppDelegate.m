//
//  AppDelegate.m
//  uTu
//
//  Created by Sankar on 25/03/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import "GooglePlusMasterViewController.h"
#import "InviteFriendsViewController.h"
#import <Social/Social.h>
#import "UIFont+uTu.h"
#import "iSpeechSDK.h"
#import <MessageUI/MessageUI.h>

@interface AppDelegate () <GPPDeepLinkDelegate>
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;
@end

@implementation AppDelegate

static NSString * const kClientId = @"454288110801-3j09f9dfto3150uajcet2bt3qcp48dd6.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if([MFMessageComposeViewController canSendText]){
        NSLog(@"SIM Available");
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Sim detected"
                                                          message:@"Application will quit now."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        message.delegate = self;
        [message show];
        NSLog(@"no SIM card installed");
    }
    
    [GPPSignIn sharedInstance].clientID = kClientId;
    [self initializeUser];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        [[[application windows] lastObject] setTintColor:[UIColor colorWithRed:((242) / 255.0f)
                                                                         green:((228) / 255.0f)
                                                                          blue:((138) / 255.0f)
                                                                         alpha:1.0f]];
    }else{
        [[[application windows] lastObject] setTintColor:[UIColor colorWithRed:((94) / 255.0f)
                                                                         green:((34) / 255.0f)
                                                                          blue:((44) / 255.0f)
                                                                         alpha:1.0f]];
    }
    
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    [ReachabilityManager isReachable];
    
    [AFUser checkUnreadMessage];
    [AFUser getChannels];
    
    [self initTimer];
    
    self.user.utuContacts = [[NSMutableDictionary alloc] init];
    self.user.temputuContacts = [[NSMutableDictionary alloc] init];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    [AFUser rewardRedeme:@"200" withType:@"Earned" quantitiy:@"" name:@""];
    [[iSpeechSDK sharedSDK] setAPIKey:@"14076a7c87838fcd3f0d65deb9ef3ab6"];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    if (self.user.isTwitter) {
        if ([[url scheme] isEqualToString:@"myapp"] == NO) return NO;
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TwitterCallback" object:d];
        return YES;
    }
    if (self.user.isFacebookAuth) {
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                        fallbackHandler:^(FBAppCall *call) {
                            NSLog(@"In fallback handler");
                        }];
    }else{
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
    
    return YES;
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

- (void)initializeUser
{
    
    if (!self.user) {
        self.user = [[AFUser alloc] init];
        if (self.user.rewardPoints) {
            self.profileView = [[UIView alloc] init];
            self.profileView.frame = CGRectMake(230, 0, 90, 44);
            self.profileView.backgroundColor = [UIColor clearColor];
            
            UILabel *points = [[UILabel alloc] init];
            points.frame = CGRectMake(10, 2, 40, 40);
            points.numberOfLines = 2;
            points.font = [UIFont Museo500Regular8];
            points.textColor = [UIColor whiteColor];
            points.text = [NSString stringWithFormat:@"%@ POINTS",self.user.rewardPoints];
            points.textAlignment = NSTextAlignmentCenter;
            [self.profileView addSubview:points];
            
            UIImageView *img =[[UIImageView alloc]init ];
            if (self.user.profilePicture) {
                img.image = self.user.profilePicture;
            }else{
                img.image = [UIImage imageNamed:@"changeProfile_settings@2x.png"];
            }
            img.frame = CGRectMake(50, 4, 36, 36);
            [self.profileView addSubview:img];
        }
    }
}

- (void) updateProfileImage{
    [self.profileView removeFromSuperview];
    self.profileView = [[UIView alloc] init];
    self.profileView.frame = CGRectMake(230, 0, 90, 44);
    self.profileView.backgroundColor = [UIColor clearColor];
    
    UILabel *points = [[UILabel alloc] init];
    points.frame = CGRectMake(10, 2, 40, 40);
    points.numberOfLines = 2;
    points.font = [UIFont Museo500Regular8];
    points.textColor = [UIColor whiteColor];
    points.text = [NSString stringWithFormat:@"%@ POINTS",self.user.rewardPoints];
    points.textAlignment = NSTextAlignmentCenter;
    [self.profileView addSubview:points];
    
    UIImageView *img =[[UIImageView alloc]init ];
    if (self.user.profilePicture) {
        img.image = self.user.profilePicture;
    }else{
        img.image = [UIImage imageNamed:@"changeProfile_settings@2x.png"];
    }
    img.frame = CGRectMake(50, 4, 36, 36);
    [self.profileView addSubview:img];
    [self.window addSubview:self.profileView];
}

+ (AFUser *)user
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] user];
}

+ (STTwitterAPI *)twitter
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] twitter];
}

+ (AppDelegate *)appDelegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (self.user.contactId) {
        [self fetchMessages:self.user.contactId];
    }
    [AFUser getChannels];
    
//    if (self.rewardTimer) {
//        [[AppDelegate user] setIsVoiceSuccess:NO];
//        [self.rewardTimer invalidate];
//        if (self.user.rewardCount - 1 != 0) {
//            [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",[[[AppDelegate user] rewardPoints] integerValue] + self.user.rewardCount - 1]];
//            [AFUser rewardRedeme:[NSString stringWithFormat:@"%d",self.user.rewardCount - 1] withType:@"Earned" quantitiy:@"" name:@""];
//            [[AppDelegate appDelegate] updateProfileImage];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *newAlert = [[UIAlertView alloc]
//                                         initWithTitle: @"Success"
//                                         message: [NSString stringWithFormat:@"You earned %d rewards successfully.",self.user.rewardCount- 1]
//                                         delegate:nil
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//                [newAlert show];
//                self.user.rewardCount = 0;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Reward" object:self];
//            });
//        }
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

#pragma mark RemoteNotificationDelegate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *trimmedString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device token after removing spaces::: %@", trimmedString);
    
    NSString *devicetoken = [trimmedString stringByReplacingOccurrencesOfString:@"[<> ]"
                                                                     withString:@""
                                                                        options:NSRegularExpressionSearch
                                                                          range:NSMakeRange(0, trimmedString.length)];
    self.device_token = devicetoken;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    UIAlertView *newAlert = [[UIAlertView alloc]
                             initWithTitle:@"Remote Notification Failure"
                             message: @"Device unable to register for remote notification. Ola Mundo will not be able to send or receive remote messages."
                             delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [self setIsRemoteNotificationEnabled:FALSE];
    [newAlert show];
}


- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    [self alertWithMessage:@"Without Completion Handler"];
    if (userInfo) {
        NSLog(@"REMOTE MESSAGE - %@", userInfo);
        [self fetchMessages:[userInfo objectForKey:@"contact_id"]];
        NSString *contactId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"contact_id"]];
        if (![[[self user] utuContacts] objectForKey:contactId]) {
            [AFUser addContact:contactId];
        }
    }else{
        NSLog(@"SOME PROBLEM WITH REMOTE NOTIFICATION");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //    [self alertWithMessage:@"With Completion Handler"];
    if (userInfo) {
        NSLog(@"REMOTE MESSAGE - %@", userInfo);
        [self fetchMessages:[userInfo objectForKey:@"contact_id"]];
        NSString *contactId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"contact_id"]];
        if (![[[self user] utuContacts] objectForKey:contactId]) {
            [AFUser addContact:contactId];
        }
    }else{
        NSLog(@"SOME PROBLEM WITH REMOTE NOTIFICATION");
    }
}

- (void) fetchMessages:(NSString*)contactId{
    void(^sendMessageCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        if (error) {
            NSLog(@"error %@",error);
            //show server error message.
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"Something went wrong. Please try again."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RelaodMessages" object:nil];
            [AFUser checkUnreadMessage];
        }
    };
    
    if (sendMessageCompletionBlock) {
        [AFUser fetchMessageWithCompletionBlock:sendMessageCompletionBlock user:self.user.id contact:contactId];
    }
}


- (void)initTimer
{
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [AFUser fetchutuContacts];
//    });
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                  target:self
                                                selector:@selector(loadContacts)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) loadContacts
{
    //comment these lines development mode
    //    NSLog(@"contact %@",[[self user] utuContacts]);
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [AFUser fetchutuContacts];
    });
}

- (void)recorderTimer{
    [self rewardTimerStarts];
    self.rewardTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                  target:self
                                                selector:@selector(rewardTimerStarts)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) rewardTimerStarts{
    if (self.user.remainingTime != 0) {
        self.user.remainingTime = self.user.remainingTime - 1;
        self.user.rewardCount = self.user.rewardCount + 1;
        NSLog(@"count : %d", self.user.rewardCount);
        
        if (self.user.remainingTime == 0) {
            [[AppDelegate user] setIsVoiceSuccess:NO];
            [self.rewardTimer invalidate];
            if (self.user.rewardCount - 1 != 0) {
                [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",[[[AppDelegate user] rewardPoints] integerValue] + self.user.rewardCount - 1]];
                [AFUser rewardRedeme:[NSString stringWithFormat:@"%d",self.user.rewardCount - 1] withType:@"Earned" quantitiy:@"" name:@""];
                [[AppDelegate appDelegate] updateProfileImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *newAlert = [[UIAlertView alloc]
                                             initWithTitle: @"Success"
                                             message: [NSString stringWithFormat:@"You earned %d points successfully.",self.user.rewardCount- 1]
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                    [newAlert show];
                    self.user.rewardCount = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reward" object:self];
                });
            }
        }
    }else{
//        [[AppDelegate user] setIsVoiceSuccess:NO];
//        [self.rewardTimer invalidate];
//        [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",[[[AppDelegate user] rewardPoints] integerValue] + self.user.rewardCount]];
//        [AFUser rewardRedeme:[NSString stringWithFormat:@"%d",self.user.rewardCount] withType:@"Earned" quantitiy:@"" name:@""];
//        [[AppDelegate appDelegate] updateProfileImage];
//        self.user.rewardCount = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reward" object:self];
    }
}

@end
