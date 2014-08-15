//
//  ContactsProfileViewController.h
//  uTu
//
//  Created by Sankar on 16/07/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ContactsProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutmeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutmeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

@property (nonatomic, strong) MBProgressHUD *mbHUD;

- (IBAction)cancelButton:(id)sender;

@end
