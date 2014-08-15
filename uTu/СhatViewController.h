//
//  СhatViewController.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/18/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsProfileViewController.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

//@property (nonatomic, strong) QBUUser *opponent;
//@property (nonatomic, strong) QBChatRoom *chatRoom;

@property (nonatomic, strong) NSMutableDictionary *contactInfo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *moreOptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addfriendToChatLabel;

@property (nonatomic, strong) ContactsProfileViewController *contactsProfileViewController;

- (IBAction)addfriendTochatButton:(id)sender;
- (IBAction)moreOptionsButton:(id)sender;

@end
