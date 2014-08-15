//
//  ChannelsViewController.m
//  uTu
//
//  Created by Sankar on 29/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "ChannelsViewController.h"
#import "ChannelsViewCell.h"
#import "UIFont+uTu.h"
#import "SelectYourShowViewController.h"

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadchannels) name:@"reloadchannels" object:Nil];
    
    self.selectChannelLabel.font = [UIFont Museo500Regular12];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
}

- (void) reloadchannels{
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
    return [[[AppDelegate user] channels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ChannelsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *chanelInfo = [[[AppDelegate user] channels] objectAtIndex:indexPath.row];
    
    cell.ChannelsName.font = [UIFont Museo500Regular12];
    
    cell.ChannelsName.text = [chanelInfo objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chanelInfo = [[[AppDelegate user] channels] objectAtIndex:indexPath.row];
    [[AppDelegate user] setSelectedChannel:[chanelInfo objectForKey:@"name"]];
    [AFUser getShows:[NSString stringWithFormat:@"%d", [[chanelInfo objectForKey:@"id"] integerValue]]];
    ((SelectYourShowViewController *)self.parentViewController).isButton = NO;
    
    [((SelectYourShowViewController *)self.parentViewController) showChannelView:NO];
}


@end
