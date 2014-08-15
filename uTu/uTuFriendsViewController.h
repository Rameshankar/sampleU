//
//  uTuFriendsViewController.h
//  uTu
//
//  Created by Sankar on 21/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface uTuFriendsViewController : UITableViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *addContactView;

@end
