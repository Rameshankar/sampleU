//
//  PointsRedmeedViewController.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsRedeemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *pointsRedeemLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateRedeemedLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemedLabel;
@property (weak, nonatomic) IBOutlet UILabel *QuantityLabel;

@end
