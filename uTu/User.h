//
//  Accounts.h
//  OlaMundo
//
//  Created by Satyen Vats on 16/02/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

@interface User : NSCache <NSCoding>{
 

}

@property BOOL isLoggedIn;
@property BOOL isVerified;
@property BOOL isFacebookAuth;
@property BOOL isTwitter;
@property BOOL isutuContactsLoaded;
@property BOOL isShowSelected;
@property BOOL isFav;
@property BOOL isVoiceSuccess;
@property int remainingTime;
@property int rewardCount;

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phoneNumer;
@property (nonatomic, strong) NSString *rewardPoints;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthdate;
@property (nonatomic, strong) NSString *aboutme;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *selectedChannel;

@property (nonatomic, strong) NSMutableDictionary *pointsHistory;
@property (nonatomic, strong) NSMutableArray *redeemHistory;
@property (nonatomic, strong) NSMutableArray *redeemOptions;
@property (nonatomic, strong) NSMutableArray *charities;
@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) NSMutableArray *selectedShows;
@property (nonatomic, strong) NSMutableArray *favShows;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableDictionary *ratings;

@property (nonatomic, strong) NSString *errorInfo;
@property (nonatomic, strong) NSMutableDictionary *utuContacts;
@property (nonatomic, strong) NSMutableDictionary *temputuContacts;
@property (nonatomic, strong) NSMutableArray *contactMessages;

@property (nonatomic, strong) NSMutableArray *localContactsKeys;

@property (nonatomic, strong) NSMutableDictionary *phoneContacts;
@property (nonatomic, strong) NSMutableDictionary *localContacts;

@property (nonatomic, strong) NSMutableDictionary *contactProfile;

@property (nonatomic, strong) UIImage *profilePicture;
@property (nonatomic, strong) NSString *modeOfKeyboard;
- (void)saveStateInUserDefaults;
- (BOOL)validateUrl:(NSString *)candidate;

@end
