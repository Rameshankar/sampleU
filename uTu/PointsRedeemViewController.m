//
//  PointsRedmeedViewController.m
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "PointsRedeemViewController.h"
#import "PointsRedeemViewCell.h"
#import "UIFont+uTu.h"

@interface PointsRedeemViewController ()

@end

@implementation PointsRedeemViewController

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
    
    self.pointsRedeemLabel.font = [UIFont Museo500Regular10];
    self.dateRedeemedLabel.font = [UIFont Museo500Regular10];
    self.redeemedLabel.font = [UIFont Museo500Regular10];
    self.QuantityLabel.font = [UIFont Museo500Regular10];
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
    return [[[AppDelegate user] redeemHistory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PointsRedeemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = [[[AppDelegate user] redeemHistory] objectAtIndex:indexPath.row];
    
    cell.pointsRedeemLabel.font = [UIFont Museo500Regular12];
    cell.dateRedeemedLabel.font = [UIFont Museo500Regular12];
    cell.redeemedLabel.font = [UIFont Museo500Regular12];
    cell.quantityLabel.font = [UIFont Museo500Regular12];
    
    cell.pointsRedeemLabel.text = [info objectForKey:@"reward_points"];
    cell.dateRedeemedLabel.text = [info objectForKey:@"created_at"];
    if ([info objectForKey:@"quantity"] && [info objectForKey:@"quantity"] != [NSNull null]) {
        cell.quantityLabel.text = [info objectForKey:@"quantity"];
    }else{
        cell.quantityLabel.text = @"";
    }
    if ([info objectForKey:@"redeemed_type"] && [info objectForKey:@"redeemed_type"] != [NSNull null]) {
        cell.redeemedLabel.text = [info objectForKey:@"redeemed_type"];
    }else{
        cell.redeemedLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 }

@end
