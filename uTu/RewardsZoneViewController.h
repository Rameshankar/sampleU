//
//  RewardsZoneViewController.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardsZoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *donateTocharityLabel;
@property (weak, nonatomic) IBOutlet UILabel *uTuNotificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemuTuPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *uTudealsLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstandLastnameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *editProfileLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsHistoryLabel;

- (IBAction)uTuDealsButton:(id)sender;
- (IBAction)donateCharityButton:(id)sender;
- (IBAction)uTuNotificationButton:(id)sender;
- (IBAction)redeemuTuPointsButton:(id)sender;
- (IBAction)photoPic:(id)sender;
- (IBAction)editProfile:(id)sender;
- (IBAction)pointsHistoryButton:(id)sender;

@end
