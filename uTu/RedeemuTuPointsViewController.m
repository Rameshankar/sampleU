//
//  RedmeeduTuPointsViewController.m
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "RedeemuTuPointsViewController.h"
#import "RedeemuTuPointsViewCell.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RedeemuTuPointsViewController ()

@end

@implementation RedeemuTuPointsViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Rewards Zone";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.youearnedHeaderLabel.font = [UIFont Museo700Regular14];
}

- (void) viewWillAppear:(BOOL)animated{
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
                [self.tableView reloadData];
            });
        }
    };
    
    if (sendProfileInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Please wait";
        self.mbHUD.detailsLabelText = @"Loading data";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser redeemOptionsWithCompletionBlock:sendProfileInfoCompletionBlock];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppDelegate user] redeemOptions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RedeemuTuPointsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = [[[AppDelegate user] redeemOptions] objectAtIndex:indexPath.row];
    
    cell.nameLabel.font = [UIFont Museo700Regular11];
    cell.nameDetailsLabel.font = [UIFont Museo500Regular10];
    cell.pointsLabel.font = [UIFont Museo500Regular10];
    
    cell.nameLabel.text = [info objectForKey:@"name"];
    cell.nameDetailsLabel.text = [info objectForKey:@"description"];
    cell.pointsLabel.text = [NSString stringWithFormat:@"%@ points each",[info objectForKey:@"reqired_points"]];
    
    cell.cartButton.accessibilityValue = [NSString stringWithFormat:@"%d",indexPath.row];
    [cell.cartButton addTarget:self
                        action:@selector(cartButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL = [NSString stringWithFormat:@"http://54.255.206.204:3000%@",[info objectForKey:@"redeem_image"]];
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.photoPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
    
    [cell.cartImageView setImageWithURL:[NSURL URLWithString:@"https://s3-ap-southeast-1.amazonaws.com/utu.images/cart.png"]];
    
    return cell;
}

- (IBAction)cartButtonClick:(id)sender{
    NSLog(@"item %@", [sender accessibilityValue]);
    NSDictionary *info = [[[AppDelegate user] redeemOptions] objectAtIndex:[[sender accessibilityValue] integerValue]];
    self.checkoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
    self.checkoutViewController.redeemOption = info;
    [self.navigationController pushViewController:self.checkoutViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *info = [[[AppDelegate user] redeemOptions] objectAtIndex:indexPath.row];
//    
//    self.checkoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
//    self.checkoutViewController.redeemOption = info;
//    [self.navigationController pushViewController:self.checkoutViewController animated:YES];
}

@end
