//
//  LocalContactsViewController.h
//  uTu
//
//  Created by Sankar on 13/07/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "СhatViewController.h"

@interface LocalContactsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ChatViewController *chatViewController;


@end
