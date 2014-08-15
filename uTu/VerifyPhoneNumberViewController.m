//
//  VerifyPhoneNumberViewController.m
//  uTu
//
//  Created by Sankar on 12/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "ProfileDetailsViewController.h"
#import "AFUser.h"
#import "AppDelegate.h"
#import "CountryListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIFont+uTu.h"
#import "VerificationCodeViewController.h"


@interface VerifyPhoneNumberViewController ()
@end

@implementation VerifyPhoneNumberViewController{
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillBeHidden:)
                                                 name: UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeInactive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.verificationCodeTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.phoneNumberTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    self.verificationCodeTextField.delegate = self;
    self.verificationCodeTextField.accessibilityValue = @"verifycode";
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.accessibilityValue = @"phonenumber";
    
//    self.verificationCodeView.hidden = NO;
    
    //get the coutry
    self.countryNameLabel.text = @"Select Country";
    self.countrystdCodeLabel.text = @"00";
    
//    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
//    self.countryNameLabel.text = countryCode;
    
    
    self.verifyphoneNumberHeaderLabel.font = [UIFont Museo700Regular14];
    self.messageLabel1.font = [UIFont Museo500Regular13];
    self.messageLabel2.font = [UIFont Museo500Regular13];
    self.countryNameLabel.font = [UIFont Museo700Regular14];
    self.countrystdCodeLabel.font = [UIFont Museo500Regular14];
    self.phoneNumberTextField.font = [UIFont Museo500Regular14];
    self.okLabel.font = [UIFont Museo500Regular14];
    self.doneLabel.font = [UIFont Museo500Regular14];
    self.skipLabel.font = [UIFont Museo500Regular14];
    
    self.pleaseenterverificationLabel.font = [UIFont Museo700Regular14];
    self.verificationCodeTextField.font = [UIFont Museo500Regular13];
    
    self.noteLabel.font = [UIFont Museo500Regular12];
    
    NSString *numb = [[AppDelegate user] phoneNumer];
    if (numb) {
        self.phoneNumberTextField.text = numb;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"verification textfield enabled");
    if ([[textField accessibilityValue] isEqualToString:@"verifycode"]) {
        isverifytextField = YES;
    }else{
        isverifytextField = NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)countryListButton:(id)sender {
//    NSArray *countryCodes = [NSLocale ISOCountryCodes];
//    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
//    
//    for (NSString *countryCode in countryCodes)
//    {
//        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
//        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
//        [countries addObject: country];
//    }
//    
//    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    
//    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
//    [self presentViewController:cv animated:YES completion:NULL];
    
//    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:Nil delegate:self];
    CountryListViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryListViewController"];
    cv.delegate = self;
    [self presentViewController:cv animated:YES completion:NULL];
}

- (void)didSelectCountry:(NSDictionary *)country
{
    NSLog(@"%@", country);
    self.countryNameLabel.text = [country objectForKey:@"name"];
    NSString *code = [country objectForKey:@"dial_code"];
    code = [code stringByReplacingOccurrencesOfString:@"+" withString:@""];
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.countrystdCodeLabel.text = code;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //Do something
        NSLog(@"edit");
        [self.phoneNumberTextField becomeFirstResponder];
    } else if (buttonIndex == 1) {
        //Do something else
        NSLog(@"ok");
        [self verifyNumber];
    }
}

- (IBAction)okButton:(id)sender {
    
    [self.phoneNumberTextField resignFirstResponder];
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
    
    if (self.phoneNumberTextField.text.length != 0 && [self.countryNameLabel.text isEqualToString:@"Select Country"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"Please select your country and then enter your phone number."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.countryNameLabel.text isEqualToString:@"Select Country"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"Please select your country and enter your phone number."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.phoneNumberTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"Please enter your phone number."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Is this your contact number? \n\n (+%@) %@ \n\n As SMS with your access code will be sent to this number",self.countrystdCodeLabel.text, self.phoneNumberTextField.text];
    UIAlertView *newAlert = [[UIAlertView alloc]
                             initWithTitle: @"Phone Number Verification"
                             message: message
                             delegate:self
                             cancelButtonTitle:@"Edit"
                             otherButtonTitles:@"Ok",nil];
    [newAlert show];
}

- (void) verifyNumber{
    if (self.phoneNumberTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"Phone number can not be blank."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self.phoneNumberTextField resignFirstResponder];
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",self.countrystdCodeLabel.text,self.phoneNumberTextField.text];
        
        [[AppDelegate user] setPhoneNumer:phoneNumber];
        
        VerifyPhoneNumberViewController * __weak weakSelf = self;
        
        void(^verifyPhoneNumberCompletionBlock)(NSError *error) = ^void(NSError *error)
        {
            [self.mbHUD setHidden:YES];
            // hide the mbHud
            if (error) {
                NSLog(@"error %@",error);
                if ([[AppDelegate user] errorInfo]) {
                    // show error message
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Validation error"
                                          message: [[AppDelegate user] errorInfo]
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Server Error"
                                          message: @"Something went wrong. Please try again."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }else{
                if ([[AppDelegate user] errorInfo]) {
                    // show error message
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Validation error"
                                          message: [[AppDelegate user] errorInfo]
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }else{
                    //show verification view
//                    self.verificationCodeView.hidden = NO;
                    VerificationCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerificationCodeViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        };
        
        if (verifyPhoneNumberCompletionBlock) {
            
            [[AppDelegate user] saveStateInUserDefaults];
            self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.mbHUD.labelText = @"sending..";
            self.mbHUD.detailsLabelText = @"sending phone number to create.";
            self.mbHUD.mode = MBProgressHUDModeIndeterminate;
            [self.view addSubview:self.mbHUD];
            
            [AFUser verifyPhoneNumberWithCompletionBlock:verifyPhoneNumberCompletionBlock];
        }
    }
}


- (IBAction)doneButton:(id)sender {
    
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
        
        VerifyPhoneNumberViewController * __weak weakSelf = self;
        
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
                                          message: @"Verification code does not match!"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }else{
                    //redirect view
                    [[AppDelegate user] setIsLoggedIn:TRUE];
                    [[AppDelegate user] setIsVerified:TRUE];
                    [[AppDelegate user] saveStateInUserDefaults];
                    self.mainTabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                    [self.navigationController pushViewController:self.mainTabBarViewController animated:YES];
                    
                }
            }
        };
        
        if (verifyUserCompletionBlock) {
            
            self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.mbHUD.labelText = @"Validating account";
            self.mbHUD.detailsLabelText = @"Your phone number is verified!";
            self.mbHUD.mode = MBProgressHUDModeIndeterminate;
            [self.view addSubview:self.mbHUD];
            
            [AFUser verifyUserWithCompletionBlock:verifyUserCompletionBlock];
        }
    }
}

- (IBAction)skipButton:(id)sender {
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
    
    VerifyPhoneNumberViewController * __weak weakSelf = self;
    
    void(^requestForCallCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        [self.mbHUD setHidden:YES];
        // hide the mbHud
        
        if (error) {
            NSLog(@"error %@",error);
        }else{
            
            
        }
    };
    
    if (requestForCallCompletionBlock) {
        [[AppDelegate user] setIsVerified:TRUE];
        [[AppDelegate user] saveStateInUserDefaults];
        
        [AFUser requestForCall:requestForCallCompletionBlock];
    }
}

-(void)dismissKeyboard {
	[self.phoneNumberTextField resignFirstResponder];
	[self.verificationCodeTextField resignFirstResponder];
}


-(void) keyboardDidShow: (NSNotification *)notif
{
    if (isverifytextField) {
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            [UIView animateWithDuration:0.2f animations:^{
                self.view.center = CGPointMake(self.view.center.x , 240 - 160);
            }];
        } else {
            [UIView animateWithDuration:0.2f animations:^{
                self.view.center = CGPointMake(self.view.center.x , 240 - 210);
            }];
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            
        } else {
            [UIView animateWithDuration:0.2f animations:^{
                self.view.center = CGPointMake(self.view.center.x , 240 - 50);
            }];
        }
    }
}

-(void) keyboardWillBeHidden: (NSNotification *)notif
{
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        [UIView animateWithDuration:0.1f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 284);
        }];

    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 240);
        }];
    }
}

- (void)becomeInactive:(NSNotification *)notification {
    [self allFieldsResignResponder];
}

- (void)allFieldsResignResponder
{
    [UIView animateWithDuration:0.5 animations:^
     {
         [self.phoneNumberTextField resignFirstResponder];
         [self.verificationCodeTextField resignFirstResponder];
     }];
}


@end
