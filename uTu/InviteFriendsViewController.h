//
//  InviteFriendsViewController.h
//  uTu
//
//  Created by Sankar on 19/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "GooglePlusMasterViewController.h"
#import "STTwitterAPI.h"

@class TwitterConsumer;
@class TwitterToken;

@interface InviteFriendsViewController : UIViewController<MFMailComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>{
@private
	STTwitterAPI* _consumer;
	TwitterToken* _token;
}

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) WelcomeViewController *welcomeViewController;
@property (nonatomic, strong) GooglePlusMasterViewController *googlemasterViewController;

@property (weak, nonatomic) IBOutlet UIButton *addfriendsViaTwitter;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *addFriendsViaFB;
@property (weak, nonatomic) IBOutlet UILabel *addFriendsViaTwitter;
@property (weak, nonatomic) IBOutlet UILabel *addFriendsViaSMS;
@property (weak, nonatomic) IBOutlet UILabel *addFriendsViaGoogle;
@property (weak, nonatomic) IBOutlet UILabel *addFriendsViauTu;

@property (nonatomic, weak) IBOutlet UILabel *loginStatusLabel;

@property (nonatomic, strong) TwitterConsumer *_consumer;
@property (nonatomic, strong) TwitterConsumer *_token;
@property (weak, nonatomic) IBOutlet UILabel *addfriendsEarnPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourearnPointsLabel;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;
- (IBAction)addfriendsViaFB:(id)sender;
- (IBAction)addfriendsViaTwitter:(id)sender;
- (IBAction)addfriendsViaSMS:(id)sender;
- (IBAction)addfriendsViaGoogle:(id)sender;
- (IBAction)InviteFriendsViauTu:(id)sender;

@end
