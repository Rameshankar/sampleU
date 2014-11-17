//
//  FavoritesViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesCell.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectYourShowViewController.h"


@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadfavprograms) name:@"reloadfavprograms" object:Nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Select your show";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.headerLabel.font = [UIFont Museo700Regular14];
    self.noFavoritiesHeaderLabel.font = [UIFont Museo700Regular14];
    self.addfromProgramLabel.font = [UIFont Museo500Regular13];
    self.searchFavoritiesShowLabel.font = [UIFont Museo500Regular13];
    
}

- (void) reloadfavprograms{
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
                if ([[[AppDelegate user] favShows] count] == 0) {
                    self.nofavoritiesshowView.hidden = NO;
                }else{
                    self.nofavoritiesshowView.hidden = YES;
                }
            });
        }
    };
    
    if (sendProfileInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Please wait";
        self.mbHUD.detailsLabelText = @"Loading data";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser userFavShowsWithCompletionBlock:sendProfileInfoCompletionBlock];
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
    return [[[AppDelegate user] favShows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *show = [[[AppDelegate user] favShows] objectAtIndex:indexPath.row];
    
    cell.nameLabel.font = [UIFont Museo500Regular13];
    cell.channelLabel.font = [UIFont Museo500Regular10];
    cell.timelLabel.font = [UIFont Museo500Regular12];
    
    cell.timelLabel.text = [show objectForKey:@"show_time"];
    cell.nameLabel.text = [show objectForKey:@"show_title"];
    cell.channelLabel.text = [show objectForKey:@"channel_name"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL;
        if ([show objectForKey:@"show_image"] != [NSNull null]) {
            imageURL = [show objectForKey:@"show_image"];
        }else{
            imageURL = [NSString stringWithFormat:@"http://54.255.206.204:3000%@",[show objectForKey:@"program_image"]];
        }
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.showImage setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *show = [[[AppDelegate user] favShows] objectAtIndex:indexPath.row];
    
    self.selectYourShowProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectYourShowProfileViewController"];
    self.selectYourShowProfileViewController.show = show;
    [self.navigationController pushViewController:self.selectYourShowProfileViewController animated:YES];
}

- (IBAction)addFromProgramButton:(id)sender {
    [((SelectYourShowViewController *)self.parentViewController) showGuid];
}

- (IBAction)searchFavoritiesShowButton:(id)sender {
    [((SelectYourShowViewController *)self.parentViewController) showSearch];
}

@end
