//
//  ProfileDetailsViewController.h
//  uTu
//
//  Created by Sankar on 12/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"
#import "MBProgressHUD.h"

@interface ProfileDetailsViewController : UIViewController <UITextFieldDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) MBProgressHUD *mbHUD;

@property (nonatomic, strong) UIPopoverController *cameraPopoverController;
@property (weak, nonatomic) IBOutlet UIButton *addphotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *addphotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *qwertyKeyboard;
@property (weak, nonatomic) IBOutlet UILabel *includeuTuLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

- (IBAction)addphotoButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)qwertyKeyboard:(id)sender;

@end
