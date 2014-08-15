//
//  DonateCharityViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DonateCheckoutViewController.h"

@interface DonateCharityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *giftSomeoneHeaderLabel;

@property (nonatomic, strong) MBProgressHUD *mbHUD;

@property (nonatomic, strong) DonateCheckoutViewController *donateCheckoutViewController;

@end
