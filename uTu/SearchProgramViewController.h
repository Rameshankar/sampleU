//
//  SearchProgramViewController.h
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYourShowProfileViewController.h"
#import "MBProgressHUD.h"

@interface SearchProgramViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *programSearchBar;

@property (nonatomic, strong) SelectYourShowProfileViewController *selectYourShowProfileViewController;
@property (nonatomic, strong) MBProgressHUD *mbHUD;

@end
