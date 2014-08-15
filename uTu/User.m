//
//  Accounts.m
//  OlaMundo
//
//  Created by Satyen Vats on 16/02/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

//#import <SDWebImage/UIImageView+WebCache.h>
#import <AudioToolbox/AudioToolbox.h>

#import "User.h"
//#import "SBJson.h"
#import "AppDelegate.h"

@interface User ()

@end

@implementation User

- (id)init
{
    self = [super init];
    if (self) {
        @try {
            NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"uTuUser"];
            if (userData) {
                self = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            }else{
                self.utuContacts = [[NSMutableDictionary alloc] init];
                self.temputuContacts = [[NSMutableDictionary alloc] init];
                self.contactMessages = [[NSMutableArray alloc] init];
                self.localContacts = [[NSMutableDictionary alloc] init];
                self.localContactsKeys = [[NSMutableArray alloc] init];
                self.rewardPoints = @"200";
            }
        }
        @catch (NSException *exception) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uTuUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"exception %@",exception);
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.isLoggedIn = [decoder decodeBoolForKey:@"isLoggedIn"];
        self.isutuContactsLoaded = [decoder decodeBoolForKey:@"isutuContactsLoaded"];
        self.isVerified = [decoder decodeBoolForKey:@"isVerified"];
        self.rewardPoints = [decoder decodeObjectForKey:@"rewardPoints"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.birthdate = [decoder decodeObjectForKey:@"birthdate"];
        self.aboutme = [decoder decodeObjectForKey:@"aboutme"];
        self.selectedChannel = [decoder decodeObjectForKey:@"selectedChannel"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.zip = [decoder decodeObjectForKey:@"zip"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.contactId = [decoder decodeObjectForKey:@"contactId"];
        self.phoneNumer = [decoder decodeObjectForKey:@"phoneNumer"];
        self.verificationCode = [decoder decodeObjectForKey:@"verificationCode"];
        self.profilePicture = [decoder decodeObjectForKey:@"profilePicture"];
        self.utuContacts = [decoder decodeObjectForKey:@"utuContacts"];
        self.localContacts = [decoder decodeObjectForKey:@"localContacts"];
        self.temputuContacts = [decoder decodeObjectForKey:@"temputuContacts"];
        self.contactMessages = [decoder decodeObjectForKey:@"contactMessages"];
        self.localContactsKeys = [decoder decodeObjectForKey:@"localContactsKeys"];
        self.pointsHistory = [decoder decodeObjectForKey:@"pointsHistory"];
        self.redeemHistory = [decoder decodeObjectForKey:@"redeemHistory"];
        self.redeemOptions = [decoder decodeObjectForKey:@"redeemOptions"];
        self.charities = [decoder decodeObjectForKey:@"charities"];
        self.channels = [decoder decodeObjectForKey:@"channels"];
        self.selectedShows = [decoder decodeObjectForKey:@"selectedShows"];
        self.favShows = [decoder decodeObjectForKey:@"favShows"];
        self.searchResults = [decoder decodeObjectForKey:@"searchResults"];
        self.redeemOptions = [decoder decodeObjectForKey:@"redeemOptions"];
        self.ratings = [decoder decodeObjectForKey:@"ratings"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeBool:self.isLoggedIn forKey:@"isLoggedIn"];
    [encoder encodeBool:self.isutuContactsLoaded forKey:@"isutuContactsLoaded"];
    [encoder encodeBool:self.isVerified forKey:@"isVerified"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.rewardPoints forKey:@"rewardPoints"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.birthdate forKey:@"birthdate"];
    [encoder encodeObject:self.aboutme forKey:@"aboutme"];
    [encoder encodeObject:self.selectedChannel forKey:@"selectedChannel"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.zip forKey:@"zip"];
    [encoder encodeObject:self.contactId forKey:@"contactId"];
    [encoder encodeObject:self.phoneNumer forKey:@"phoneNumer"];
    [encoder encodeObject:self.profilePicture forKey:@"profilePicture"];
    [encoder encodeObject:self.verificationCode forKey:@"verificationCode"];
    [encoder encodeObject:self.utuContacts forKey:@"utuContacts"];
    [encoder encodeObject:self.localContacts forKey:@"localContacts"];
    [encoder encodeObject:self.temputuContacts forKey:@"temputuContacts"];
    [encoder encodeObject:self.pointsHistory forKey:@"pointsHistory"];
    [encoder encodeObject:self.redeemHistory forKey:@"redeemHistory"];
    [encoder encodeObject:self.localContactsKeys forKey:@"localContactsKeys"];
    [encoder encodeObject:self.redeemOptions forKey:@"redeemOptions"];
    [encoder encodeObject:self.charities forKey:@"charities"];
    [encoder encodeObject:self.channels forKey:@"channels"];
    [encoder encodeObject:self.selectedShows forKey:@"selectedShows"];
    [encoder encodeObject:self.favShows forKey:@"favShows"];
    [encoder encodeObject:self.searchResults forKey:@"searchResults"];
    [encoder encodeObject:self.ratings forKey:@"ratings"];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteMessageReceived" object:nil];
}

- (void)saveStateInUserDefaults
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"uTuUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

@end
