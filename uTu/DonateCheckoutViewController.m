//
//  DonateCheckoutViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "DonateCheckoutViewController.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectYourShowViewController.h"

@interface DonateCheckoutViewController ()

@end

@implementation DonateCheckoutViewController{
    BOOL isverifytextField;
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
    
    self.goforitHeaderLabel.font = [UIFont Museo700Regular14];
    self.charityNameLabel.font = [UIFont Museo500Regular13];
    self.causeLabel.font = [UIFont Museo500Regular13];
    self.operatingfromLabel.font = [UIFont Museo500Regular13];
    self.websiteLabel.font = [UIFont Museo500Regular13];
    self.pointsReceivedfarLabel.font = [UIFont Museo500Regular13];
    self.pointsReceivedfarValueLabel.font = [UIFont Museo500Regular13];
    
    self.noteLabelOne.font = [UIFont Museo500Regular10];
    self.noteLabelTwo.font = [UIFont Museo500Regular10];
    
    self.likeDonatePointsLabel.font = [UIFont Museo500Regular13];
    self.pointsLabel.font = [UIFont Museo500Regular13];
    self.selectPointsLabel.font = [UIFont Museo500Regular13];
    self.changeCharityLabel.font = [UIFont Museo500Regular13];
    self.donateMorePointsLabel.font = [UIFont Museo500Regular13];
    self.donateNowLabel.font = [UIFont Museo500Regular13];
    
    self.firstalertLabel1.font = [UIFont Museo500Regular12];
    self.firstAlertLabel2.font = [UIFont Museo500Regular10];
    
    self.charityNameLabel.text = [[self charity] objectForKey:@"name"];
    self.causeLabel.text = [[self charity] objectForKey:@"cause"];
    self.operatingfromLabel.text = [[self charity] objectForKey:@"operating_from"];
    self.websiteLabel.text = [[self charity] objectForKey:@"website"];
    self.pointsReceivedfarValueLabel.text = [[self charity] objectForKey:@"charity_points"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL = [NSString stringWithFormat:@"http://54.255.206.204:3000%@",[[self charity] objectForKey:@"charity_image"]];
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.photoPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
    
    [self.selectPointsLabel setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillBeHidden:)
                                                 name: UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)dismissKeyboard {
	[self.selectPointsLabel resignFirstResponder];
}

-(void) keyboardDidShow: (NSNotification *)notif
{
    if ([UIScreen mainScreen].bounds.size.height == 568) {

    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 240 - 40);
        }];
    }
}

-(void) keyboardWillBeHidden: (NSNotification *)notif
{
    if ([UIScreen mainScreen].bounds.size.height == 568) {
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 240 + 20);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPointsButton:(id)sender {
}

- (IBAction)donateNowButton:(id)sender {
//    self.firstAleartView.hidden = NO;

    if (self.selectPointsLabel.text.length == 0) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Oops!"
                                 message: @"Please enter points."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
        return;
    }
    int availPoints = [[[AppDelegate user] rewardPoints] integerValue];
    int pointsEntered = [self.selectPointsLabel.text integerValue];
    
    if (availPoints < pointsEntered) {
        self.secondAlertView.hidden = NO;
        return;
    }else{
        self.firstAleartView.hidden = NO;
        [AFUser rewardRedeme:[NSString stringWithFormat:@"%d",pointsEntered] withType:@"Redeem" quantitiy:@"Charity" name:@"Charity"];
        availPoints = availPoints - pointsEntered;
        [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",availPoints]];
        NSLog(@"chartiyId %@", [self.charity objectForKey:@"id"]);
        [AFUser addcharityPoints:[NSString stringWithFormat:@"%ld",(long)[[self.charity objectForKey:@"id"] integerValue]] withPoints:[NSString stringWithFormat:@"%d",pointsEntered]];
        
        int pointsreceived = [self.pointsReceivedfarValueLabel.text integerValue];
        self.pointsReceivedfarValueLabel.text = [NSString stringWithFormat:@"%d", pointsEntered + pointsreceived];
        self.selectPointsLabel.text = @"";
        [[AppDelegate appDelegate] updateProfileImage];
    }
}

- (IBAction)donateMorePointsButton:(id)sender {
    self.selectYourShowViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectYourShowViewController"];
    [self.navigationController pushViewController:self.selectYourShowViewController animated:YES];
}

- (IBAction)photoPic:(id)sender {
}

- (IBAction)changeCharityButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)firstAlertCloseButton:(id)sender {
    self.firstAleartView.hidden = YES;
}

- (IBAction)secondAlertCloseButton:(id)sender {
    self.secondAlertView.hidden = YES;
}
@end
