//
//  DonateCheckoutViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYourShowViewController.h"

@interface DonateCheckoutViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *selectPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *pointsReceivedfarValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsReceivedfarLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatingfromLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *donateNowLabel;
@property (weak, nonatomic) IBOutlet UILabel *donateMorePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *causeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *charityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeCharityLabel;
@property (weak, nonatomic) IBOutlet UILabel *goforitHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *firstAleartView;
@property (weak, nonatomic) IBOutlet UILabel *firstalertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *firstAlertLabel2;
@property (weak, nonatomic) IBOutlet UIView *secondAlertView;
@property (weak, nonatomic) IBOutlet UILabel *secondAlertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *secondAlertLabel2;
@property (weak, nonatomic) IBOutlet UILabel *secondAlertSorryLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeDonatePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (nonatomic, strong) NSDictionary *charity;
@property (nonatomic, strong) SelectYourShowViewController *selectYourShowViewController;

- (IBAction)selectPointsButton:(id)sender;
- (IBAction)donateNowButton:(id)sender;
- (IBAction)donateMorePointsButton:(id)sender;
- (IBAction)photoPic:(id)sender;
- (IBAction)changeCharityButton:(id)sender;
- (IBAction)firstAlertCloseButton:(id)sender;
- (IBAction)secondAlertCloseButton:(id)sender;

@end
