//
//  uTuNotificationViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "uTuNotificationViewController.h"
#import "UIFont+uTu.h"

@interface uTuNotificationViewController ()

@end

@implementation uTuNotificationViewController

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
    
    self.uTuUpdateHeaderLabel.font = [UIFont Museo700Regular14];
    self.thereareNoUpdatesLabel.font = [UIFont Museo700Regular18];
    self.moreFeaturesLabel.font = [UIFont Museo700Regular18];
    
    self.doitLaterLabel.font = [UIFont Museo500Regular13];
    self.updateNowLabel.font = [UIFont Museo500Regular13];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updatesNowButton:(id)sender {
}

- (IBAction)doitLaterButton:(id)sender {
}
@end
