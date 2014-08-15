//
//  SelectYourShowProfileViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVViewController.h"
#import "FunWithFriendsViewController.h"

@class ASStarRatingView;
@interface SelectYourShowProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *yourSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratethisShowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *tuneInLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareWithFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addFavoritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *eligibleuTuPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *remindMeLabel;
@property (weak, nonatomic) IBOutlet UIView *tempView;
@property (weak, nonatomic) IBOutlet UIView *remindView;
@property (weak, nonatomic) IBOutlet UIView *ratethisView;
@property (weak, nonatomic) IBOutlet UIView *remindMeView;

@property (nonatomic, strong) NSDictionary *show;
@property (nonatomic, strong) TVViewController *tvViewController;
@property (nonatomic, strong) FunWithFriendsViewController *funWithFriendsViewController;
@property (retain, nonatomic) IBOutlet ASStarRatingView *staticStarRatingView;

- (IBAction)rateThisShowButton:(id)sender;
- (IBAction)tuneInButton:(id)sender;
- (IBAction)addFavoritesButton:(id)sender;
- (IBAction)shareFriendsButton:(id)sender;
- (IBAction)remindMe:(id)sender;

@end
