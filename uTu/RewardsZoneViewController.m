//
//  RewardsZoneViewController.m
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "RewardsZoneViewController.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RewardsZoneViewController ()

@end

@implementation RewardsZoneViewController

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
    
    self.firstandLastnameLabel.font = [UIFont Museo500Regular13];
    self.pointsLabel.font = [UIFont Museo500Regular13];
    self.statusLabel.font = [UIFont Museo500Regular13];
    self.emailLabel.font = [UIFont Museo500Regular13];
    self.editProfileLabel.font = [UIFont Museo500Regular13];
    self.pointsHistoryLabel.font = [UIFont Museo500Regular13];
    self.uTudealsLabel.font = [UIFont Museo500Regular13];
    self.redeemuTuPointsLabel.font = [UIFont Museo500Regular13];
    self.donateTocharityLabel.font = [UIFont Museo500Regular13];
    self.uTuNotificationLabel.font = [UIFont Museo500Regular13];
    
    if ([[AppDelegate user] profilePicture]) {
        self.photoPic.image = [[AppDelegate user] profilePicture];
    } else{
//        self.photoPic.image = [UIImage imageNamed:@"AppIcon29x29.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoPic setImageWithURL:[NSURL URLWithString:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA"] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        });
    }
    
    [self loadData];
    
}

- (void) loadData{
    self.firstandLastnameLabel.text = [[AppDelegate user] username];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points",[[AppDelegate user] rewardPoints]];
    self.statusLabel.text = [[AppDelegate user] status];
    self.emailLabel.text = [[AppDelegate user] email];
}

- (void) viewWillAppear:(BOOL)animated{
    [[AppDelegate appDelegate] updateProfileImage];
    if ([[AppDelegate user] profilePicture]) {
        self.photoPic.image = [[AppDelegate user] profilePicture];
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoPic setImageWithURL:[NSURL URLWithString:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA"] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        });
    }
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uTuDealsButton:(id)sender {
}

- (IBAction)donateCharityButton:(id)sender {
}

- (IBAction)uTuNotificationButton:(id)sender {
}

- (IBAction)redeemuTuPointsButton:(id)sender {
}

- (IBAction)photoPic:(id)sender {
}

- (IBAction)editProfile:(id)sender {
}

- (IBAction)pointsHistoryButton:(id)sender {
}
@end
