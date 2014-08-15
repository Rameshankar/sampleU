//
//  FavoritesViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYourShowProfileViewController.h"
#import "MBProgressHUD.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *nofavoritiesshowView;
@property (weak, nonatomic) IBOutlet UILabel *noFavoritiesHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *addfromProgramLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchFavoritiesShowLabel;

- (IBAction)addFromProgramButton:(id)sender;
- (IBAction)searchFavoritiesShowButton:(id)sender;

@property (nonatomic, strong) SelectYourShowProfileViewController *selectYourShowProfileViewController;
@property (nonatomic, strong) MBProgressHUD *mbHUD;


@end
