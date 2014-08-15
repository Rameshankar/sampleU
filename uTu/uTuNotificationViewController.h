//
//  uTuNotificationViewController.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uTuNotificationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *uTuUpdateHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *thereareNoUpdatesLabel;
@property (weak, nonatomic) IBOutlet UIView *moreFeaturesView;
@property (weak, nonatomic) IBOutlet UILabel *moreFeaturesLabel;
@property (weak, nonatomic) IBOutlet UILabel *doitLaterLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateNowLabel;

- (IBAction)updatesNowButton:(id)sender;
- (IBAction)doitLaterButton:(id)sender;

@end
