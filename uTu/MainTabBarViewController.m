//
//  MainTabBarViewController.m
//  uTu
//
//  Created by Sankar on 17/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

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
	// Do any additional setup after loading the view.
//    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:206.0/256.0 green:221.0/256.0 blue:166.0/256.0 alpha:1];
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]) {
        for(UITabBarItem* item in self.tabBar.items)
        {
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName : self.tabBar.tintColor} forState:UIControlStateSelected];
        }
    }
    
    [self setSelectedIndex: 2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
