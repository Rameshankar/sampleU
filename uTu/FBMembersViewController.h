//
//  FBMembersViewController.h
//  uTu
//
//  Created by Sankar on 05/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBMembersViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *ImagePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)inviteButton:(id)sender;

@end
