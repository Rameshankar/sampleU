//
//  SearchProgramViewController.m
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "SearchProgramViewController.h"
#import "SearchProgramCell.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchProgramViewController ()

@end

@implementation SearchProgramViewController{
    UIView *tempView;
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.programSearchBar.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(void)dismissKeyboard {
	[self.programSearchBar resignFirstResponder];
    [tempView removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    tempView = [[UIView alloc] init];
    tempView.frame = self.view.frame;
    [self.view addSubview:tempView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tempView addGestureRecognizer:tap];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [tempView removeFromSuperview];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    [self.programSearchBar resignFirstResponder];
    if (self.programSearchBar.text.length == 0) {
        return;
    }
    void(^sendProfileInfoCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mbHUD setHidden:YES];
        });
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
        
        [AFUser searchShowsWithCompletionBlock:sendProfileInfoCompletionBlock text:self.programSearchBar.text];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppDelegate user] searchResults] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *show = [[[AppDelegate user] searchResults] objectAtIndex:indexPath.row];
    
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
    NSDictionary *show = [[[AppDelegate user] searchResults] objectAtIndex:indexPath.row];
    
    self.selectYourShowProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectYourShowProfileViewController"];
    self.selectYourShowProfileViewController.show = show;
    [self.navigationController pushViewController:self.selectYourShowProfileViewController animated:YES];
}


@end
