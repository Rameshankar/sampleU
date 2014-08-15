//
//  ChannelsViewController.h
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *selectChannelLabel;

@end
