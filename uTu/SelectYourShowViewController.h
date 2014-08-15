//
//  SelectYourShowViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SelectYourShowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *favoritesContainerView;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UIView *guideContainerView;
@property (weak, nonatomic) IBOutlet UIView *channelsContainerView;

@property BOOL isButton;
- (IBAction)segmentedControl:(UISegmentedControl *)sender;

- (void) showChannelView:(BOOL)option;

@property (nonatomic, strong) MBProgressHUD *mbHUD;

- (void) showGuid;
- (void) showSearch;

@end
