//
//  PointsHistoryViewController.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PointsHistoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *youruTuPointsHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsearnedtillDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsredmeedtillDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsEarnedLastmonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsEarnedLastweekLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsearnedtilldatevalue;
@property (weak, nonatomic) IBOutlet UILabel *pointsredmeedtillDateValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsearnedlastmonthValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsearnedLastweekValue;
@property (weak, nonatomic) IBOutlet UILabel *redeemuTuPointsLabel;
@property (weak, nonatomic) IBOutlet UIView *pointsRedeemedContainerView;

@property (nonatomic, strong) MBProgressHUD *mbHUD;

- (IBAction)redeemuTuPoints:(id)sender;
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;

@end
