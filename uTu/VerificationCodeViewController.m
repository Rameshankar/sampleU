//
//  VerificationCodeViewController.m
//  uTu
//
//  Created by Sankar on 25/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "UIFont+uTu.h"
#import "AFUser.h"
#import "AppDelegate.h"
#import "MainTabBarViewController.h"

@interface VerificationCodeViewController ()

@end

@implementation VerificationCodeViewController{
     BOOL isverifytextField;
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
    
    [self.verificationCodeTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.accessibilityValue = @"verifycode";
    
    self.verificationCodeTextField.font = [UIFont Museo500Regular13];
    self.reenterNumberLabel.font = [UIFont Museo500Regular12];
    self.callmewithCodeLabel.font = [UIFont Museo500Regular12];
    
    [self.verificationCodeTextField becomeFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Success"
                                 message: @"Verification code sent to your mobile. Please check!"
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender{
    if (![ReachabilityManager isReachable]) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"No Internet connection"
                                 message: @"Please check your internet connection."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
        return;
    }
    
    if (self.verificationCodeTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"verification code can not be blank."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self.verificationCodeTextField resignFirstResponder];
        NSString *verificationCode = self.verificationCodeTextField.text;
        
        [[AppDelegate user] setVerificationCode:verificationCode];
        
        VerificationCodeViewController * __weak weakSelf = self;
        
        void(^verifyUserCompletionBlock)(NSError *error) = ^void(NSError *error)
        {
            [self.mbHUD setHidden:YES];
            // hide the mbHud
            if (error) {
                NSLog(@"error %@",error);
                //show server error message.
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Server Error"
                                      message: @"Something went wrong. Please try again."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }else{
                if ([[AppDelegate user] errorInfo]) {
                    // show error message
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Validation error"
                                          message: @"Invalid verification code"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }else{
                    //redirect view
                    [[AppDelegate user] setIsLoggedIn:TRUE];
                    [[AppDelegate user] setIsVerified:TRUE];
                    [AFUser rewardRedeme:@"200" withType:@"Earned" quantitiy:@"" name:@""];
                    [[AppDelegate user] saveStateInUserDefaults];
                    self.mainTabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                    [self.navigationController pushViewController:self.mainTabBarViewController animated:YES];
                    
                }
            }
        };
        
        if (verifyUserCompletionBlock) {
            
            self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.mbHUD.labelText = @"Validating account";
            self.mbHUD.detailsLabelText = @"phone number and velidationcode are being checked";
            self.mbHUD.mode = MBProgressHUDModeIndeterminate;
            [self.view addSubview:self.mbHUD];
            
            [AFUser verifyUserWithCompletionBlock:verifyUserCompletionBlock];
        }
    }

}

- (IBAction)skipButton:(id)sender{
    [[AppDelegate user] setIsVerified:TRUE];
    [[AppDelegate user] setIsVerified:FALSE];
    [[AppDelegate user] saveStateInUserDefaults];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"uTu"
                          message: @"Soon you will recive a verification call from utu."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    VerificationCodeViewController * __weak weakSelf = self;
    
    void(^requestForCallCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        [self.mbHUD setHidden:YES];
        // hide the mbHud
        
        if (error) {
            NSLog(@"error %@",error);
        }else{
            [AFUser rewardRedeme:@"200" withType:@"Earned" quantitiy:@"" name:@""];
            
        }
    };
    
    if (requestForCallCompletionBlock) {
        [[AppDelegate user] setIsVerified:TRUE];
        [[AppDelegate user] saveStateInUserDefaults];
        
        [AFUser requestForCall:requestForCallCompletionBlock];
    }

}
- (IBAction)editNumberButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
