//
//  PointsHistoryViewController.m
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "PointsHistoryViewController.h"
#import "UIFont+uTu.h"

@interface PointsHistoryViewController ()

@end

@implementation PointsHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Rewards Zone";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.youruTuPointsHeaderLabel.font = [UIFont Museo700Regular14];
    self.totalPointsLabel.font = [UIFont Museo500Regular13];
    self.totalPointsValueLabel.font = [UIFont Museo500Regular13];
    self.pointsearnedtillDateLabel.font = [UIFont Museo500Regular13];
    self.pointsearnedtilldatevalue.font = [UIFont Museo500Regular13];
    self.pointsredmeedtillDateLabel.font = [UIFont Museo500Regular13];
    self.pointsredmeedtillDateValue.font = [UIFont Museo500Regular13];
    self.pointsEarnedLastmonthLabel.font = [UIFont Museo500Regular13];
    self.pointsearnedlastmonthValue.font = [UIFont Museo500Regular13];
    self.pointsEarnedLastweekLabel.font = [UIFont Museo500Regular13];
    self.pointsearnedLastweekValue.font = [UIFont Museo500Regular13];
    self.redeemuTuPointsLabel.font = [UIFont Museo500Regular13];
    
    self.totalPointsValueLabel.text = [[AppDelegate user] rewardPoints];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [AFUser pointsHistoryWithCompletionBlock:nil];
    void(^sendProfileInfoCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        [self.mbHUD setHidden:YES];
        if (error) {
            NSLog(@"error %@",error);
            //show server error message. username is already taken
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"Please check your internet connection"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *info = [[[AppDelegate user] pointsHistory] objectForKey:@"user"];
                self.totalPointsValueLabel.text = [info objectForKey:@"available_points"];
                self.pointsearnedtilldatevalue.text = [NSString stringWithFormat:@"%d",[[info objectForKey:@"total_earned_points"] integerValue]];
                self.pointsredmeedtillDateValue.text = [NSString stringWithFormat:@"%d",[[info objectForKey:@"total_redeemed_points"] integerValue]];
                self.pointsearnedlastmonthValue.text = [NSString stringWithFormat:@"%d",[[info objectForKey:@"earned_points_last_month"] integerValue]];
                self.pointsearnedLastweekValue.text = [NSString stringWithFormat:@"%d",[[info objectForKey:@"earned_points_last_week"] integerValue]];
                [[AppDelegate user] setRewardPoints:self.totalPointsValueLabel.text];
                [[AppDelegate appDelegate] updateProfileImage];
                [[AppDelegate user] saveStateInUserDefaults];
            });
        }
    };
    
    if (sendProfileInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Please wait";
        self.mbHUD.detailsLabelText = @"Loading your details";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser redeemHistoryWithCompletionBlock:sendProfileInfoCompletionBlock];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redeemuTuPoints:(id)sender {
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.pointsRedeemedContainerView.hidden = YES;
            break;
        case 1:
            self.pointsRedeemedContainerView.hidden = NO;
            
        default:
            break;
    }

}
@end
