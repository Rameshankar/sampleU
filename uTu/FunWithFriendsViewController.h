//
//  FunWithFriendsViewController.h
//  uTu
//
//  Created by Sankar on 11/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uTuFriendsViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface FunWithFriendsViewController : UIViewController<UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *inviteFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatWithFriendsLabel;

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) uTuFriendsViewController *uTufriendsviewController;

- (IBAction)inviteFriends:(id)sender;
- (IBAction)chatWithFriends:(id)sender;

@end
