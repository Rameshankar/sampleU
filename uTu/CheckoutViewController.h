//
//  CheckoutViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileRewardsZoneViewController.h"
#import "SelectYourShowViewController.h"

@interface CheckoutViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *movieTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *editDeliveryDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *goforitLabel;
@property (weak, nonatomic) IBOutlet UIView *firstalertView;
@property (weak, nonatomic) IBOutlet UILabel *firstalertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *firstalertLabel2;
@property (weak, nonatomic) IBOutlet UIView *secondalertView;
@property (weak, nonatomic) IBOutlet UILabel *secondalertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *secondalertLabel2;
@property (weak, nonatomic) IBOutlet UILabel *secondalertSorryLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdAlertView;
@property (weak, nonatomic) IBOutlet UILabel *thirdAlertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *thirdAlertLabel2;
@property (weak, nonatomic) IBOutlet UILabel *thirdalertSorryLabel;

@property (nonatomic, strong) NSDictionary *redeemOption;
@property (nonatomic, strong) EditProfileRewardsZoneViewController *editProfileRewardsZoneViewController;
@property (nonatomic, strong) SelectYourShowViewController *selectYourShowViewController;

- (IBAction)checkoutButton:(id)sender;
- (IBAction)redeemPointsButton:(id)sender;
- (IBAction)selectMovieButton:(id)sender;
- (IBAction)quantityButton:(id)sender;
- (IBAction)photoPic:(id)sender;
- (IBAction)EditDeliveryDetailsButton:(id)sender;
- (IBAction)firstAlertCloseButton:(id)sender;
- (IBAction)secondAlertCloseButton:(id)sender;
- (IBAction)thirdAlertCloseButton:(id)sender;

@end
