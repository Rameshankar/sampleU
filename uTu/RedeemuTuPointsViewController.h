//
//  RedmeeduTuPointsViewController.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CheckoutViewController.h"

@interface RedeemuTuPointsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *youearnedHeaderLabel;

@property (nonatomic, strong) MBProgressHUD *mbHUD;

@property (nonatomic, strong) CheckoutViewController *checkoutViewController;


@end
