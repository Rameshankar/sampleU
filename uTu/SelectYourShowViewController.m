//
//  SelectYourShowViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "SelectYourShowViewController.h"
#import "UIFont+uTu.h"
#import "AppDelegate.h"

@interface SelectYourShowViewController ()

@end

@implementation SelectYourShowViewController

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
        nav_titlelbl.text=@"Select Your Show";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [[AppDelegate user] setIsFav:NO];
            self.favoritesContainerView.hidden = YES;
            self.searchContainerView.hidden = YES;
            break;
        case 1:
            [[AppDelegate user] setIsFav:YES];
            self.favoritesContainerView.hidden = NO;
            self.searchContainerView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadfavprograms" object:Nil];
            break;
        case 2:
            [[AppDelegate user] setIsFav:NO];
            self.favoritesContainerView.hidden = YES;
            self.searchContainerView.hidden = NO;
        default:
            break;
    }
}

- (void) showGuid{
    self.favoritesContainerView.hidden = YES;
    self.searchContainerView.hidden = YES;
}

- (void) showSearch{
    self.favoritesContainerView.hidden = YES;
    self.searchContainerView.hidden = NO;
}

- (void) showChannelView:(BOOL)option{
    if (self.isButton) {
        [UIView animateWithDuration:0.4 animations:^{
            self.guideContainerView.frame = CGRectMake(130, 46, 320, self.view.frame.size.height);
        }completion:^(BOOL finished){
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.guideContainerView.frame = CGRectMake(0, 46, 320, self.view.frame.size.height);
        }completion:^(BOOL finished){
        }];
    }
}


@end
