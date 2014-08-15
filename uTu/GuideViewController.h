//
//  GuideViewController.h
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYourShowProfileViewController.h"

@interface GuideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *ChannelLabel;

- (IBAction)ChannelButton:(id)sender;

@property (nonatomic, strong) SelectYourShowProfileViewController *selectYourShowProfileViewController;

@end
