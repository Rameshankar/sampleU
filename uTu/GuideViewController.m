//
//  GuideViewController.m
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "GuideViewController.h"
#import "UIFont+uTu.h"
#import "GuideViewCell.h"
#import "SelectYourShowViewController.h"
#import "ChannelsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface GuideViewController ()

@end

@implementation GuideViewController{
    BOOL isButton;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadprograms) name:@"reloadprograms" object:Nil];
    
    isButton = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.headerLabel.font = [UIFont Museo700Regular14];
    self.ChannelLabel.font = [UIFont Museo500Regular10];
    
    self.headerLabel.text = [[AppDelegate user] selectedChannel];
    
}

- (void) reloadprograms{
    self.headerLabel.text = [[AppDelegate user] selectedChannel];
    [self.tableView reloadData];
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
    return [[[AppDelegate user] selectedShows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GuideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *show = [[[AppDelegate user] selectedShows] objectAtIndex:indexPath.row];
    
    cell.nameLabel.font = [UIFont Museo500Regular13];
    cell.channelLabel.font = [UIFont Museo500Regular10];
    cell.timelLabel.font = [UIFont Museo500Regular12];
    
    cell.timelLabel.text = [show objectForKey:@"show_time"];
    cell.nameLabel.text = [show objectForKey:@"show_title"];
    cell.channelLabel.text = [[AppDelegate user] selectedChannel];
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
    NSDictionary *show = [[[AppDelegate user] selectedShows] objectAtIndex:indexPath.row];
    
    self.selectYourShowProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectYourShowProfileViewController"];
    self.selectYourShowProfileViewController.show = show;
    [self.navigationController pushViewController:self.selectYourShowProfileViewController animated:YES];
}

- (IBAction)ChannelButton:(id)sender {
    if (!((SelectYourShowViewController *)self.parentViewController).isButton) {
        ((SelectYourShowViewController *)self.parentViewController).isButton = YES;
    }else{
        ((SelectYourShowViewController *)self.parentViewController).isButton = NO;
    }
    
    [((SelectYourShowViewController *)self.parentViewController) showChannelView:isButton];
}
@end
