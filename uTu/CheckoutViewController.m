
//
//  CheckoutViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "CheckoutViewController.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EditProfileRewardsZoneViewController.h"
#import "SelectYourShowViewController.h"

@interface CheckoutViewController ()
@property (nonatomic, strong) NSMutableArray *movies;
@end

@implementation CheckoutViewController{
    UIActionSheet *actionSheet1;
    UIActionSheet *actionSheet2;
}

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
    
    self.movies = [[NSMutableArray alloc] init];
    NSArray *movies = [self.redeemOption objectForKey:@"movies"];
    
    for (int i=0; i< movies.count; i++) {
        NSDictionary *movie = [movies objectAtIndex:i];
        [self.movies addObject:[movie objectForKey:@"name"]];
    }
    
    NSLog(@"movies %@", self.movies);
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Rewards Zone";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.goforitLabel.font = [UIFont Museo700Regular14];
    self.movieTicketsLabel.font = [UIFont Museo500Regular13];
    self.pointsLabel.font = [UIFont Museo500Regular13];
    self.quantityLabel.font = [UIFont Museo500Regular13];
    self.selectMovieLabel.font = [UIFont Museo500Regular13];
    self.noteLabel.font = [UIFont Museo500Regular10];
    self.editDeliveryDetailsLabel.font = [UIFont Museo500Regular13];
    self.redeemPointsLabel.font = [UIFont Museo500Regular13];
    self.checkoutLabel.font = [UIFont Museo500Regular13];
    self.firstalertLabel1.font = [UIFont Museo500Regular12];
    self.firstalertLabel2.font = [UIFont Museo500Regular10];
    self.secondalertLabel1.font = [UIFont Museo500Regular12];
    self.secondalertLabel2.font = [UIFont Museo500Regular10];
    self.secondalertSorryLabel.font = [UIFont Museo500Regular12];
    self.thirdAlertLabel1.font = [UIFont Museo500Regular12];
    self.thirdAlertLabel2.font = [UIFont Museo500Regular10];
    self.thirdalertSorryLabel.font = [UIFont Museo500Regular12];
    
    NSLog(@"%@",self.redeemOption);
    
    self.quantityLabel.text = @"Quantity";
    self.movieTicketsLabel.text = @"Select Your Movie";
    
    self.movieTicketsLabel.text = [self.redeemOption objectForKey:@"name"];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points each",[self.redeemOption objectForKey:@"reqired_points"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL = [NSString stringWithFormat:@"http://54.255.206.204:3000%@",[self.redeemOption objectForKey:@"redeem_image"]];
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.photoPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutButton:(id)sender {
    
    if ([self.quantityLabel.text isEqualToString:@"Quantity"]) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Oops!"
                                 message: @"Please select quantity."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
        return;
    }
    
    if ([self.selectMovieLabel.text isEqualToString:@"Select Your Movie"]) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Oops!"
                                 message: @"Please select movie."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
        return;
    }
    
    int availPoints = [[[AppDelegate user] rewardPoints] integerValue];
    int rewards_required = [[self.redeemOption objectForKey:@"reqired_points"] integerValue];
//    int quantity = [[self.redeemOption objectForKey:@"quantity"] integerValue];
    int selectedQuantity = [self.quantityLabel.text integerValue];
    
    if (availPoints < (selectedQuantity * rewards_required)) {
        self.secondalertView.hidden = NO;
        int actualpoints = [[self.redeemOption objectForKey:@"reqired_points"] integerValue];
        int points = [[[AppDelegate user] rewardPoints] integerValue];
        self.secondalertLabel1.text = [NSString stringWithFormat:@"You are only %d points away from earning this reward!",actualpoints - points];
        return;
    }else{
        self.firstalertView.hidden = NO;
        [AFUser rewardRedeme:[NSString stringWithFormat:@"%d",selectedQuantity * rewards_required] withType:@"Redeem" quantitiy:self.quantityLabel.text name:self.selectMovieLabel.text];
        availPoints = availPoints - selectedQuantity * rewards_required;
        [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",availPoints]];
        return;
    }
    
    if ([[[AppDelegate user] email] length] == 0 || [[[AppDelegate user] address] length] == 0 || [[[AppDelegate user] city] length] == 0 || [[[AppDelegate user] state] length] == 0 || [[[AppDelegate user] zip] length] == 0) {
        self.thirdAlertView.hidden = NO;
        return;
    }
}

- (IBAction)redeemPointsButton:(id)sender {
    self.selectYourShowViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectYourShowViewController"];
    [self.navigationController pushViewController:self.selectYourShowViewController animated:YES];
}

- (IBAction)selectMovieButton:(id)sender {
    actionSheet2 = [[UIActionSheet alloc] initWithTitle:@"Please select movie" delegate:self cancelButtonTitle:@"Cancel"  destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int i=0; i<self.movies.count; i++) {
        [actionSheet2 addButtonWithTitle:[self.movies objectAtIndex:i]];
    }
    [actionSheet2 showInView:self.view];
}

- (IBAction)quantityButton:(id)sender {
    actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Please select qunatity" delegate:self cancelButtonTitle:@"Cancel"  destructiveButtonTitle:nil otherButtonTitles:@"1",@"2",@"3",@"4",Nil];

    [actionSheet1 showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == actionSheet1) {
        NSLog(@"actionsheet1");
        if (buttonIndex == 0) {
            self.quantityLabel.text = @"1";
        }
        if (buttonIndex == 1) {
            self.quantityLabel.text = @"2";
        }
        if (buttonIndex == 2) {
            self.quantityLabel.text = @"3";
        }if (buttonIndex == 3) {
            self.quantityLabel.text = @"4";
        }
    }else if (actionSheet == actionSheet2) {
        NSLog(@"actionsheet1");
        if (buttonIndex != 0) {
            self.selectMovieLabel.text = [self.movies objectAtIndex:buttonIndex-1];
        }
//        if (buttonIndex == 1) {
//            self.selectMovieLabel.text = @"movie2";
//        }
//        if (buttonIndex == 2) {
//            self.selectMovieLabel.text = @"movie3";
//        }
    }
}

- (IBAction)photoPic:(id)sender {
}

- (IBAction)EditDeliveryDetailsButton:(id)sender {
    self.editProfileRewardsZoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileRewardsZoneViewController"];
    [self.navigationController pushViewController:self.editProfileRewardsZoneViewController animated:YES];
}

- (IBAction)firstAlertCloseButton:(id)sender {
    self.firstalertView.hidden = YES;
}

- (IBAction)secondAlertCloseButton:(id)sender {
    self.secondalertView.hidden = YES;
}

- (IBAction)thirdAlertCloseButton:(id)sender {
    self.thirdAlertView.hidden = YES;
}
@end
