//
//  adduTuContactsViewController.m
//  uTu
//
//  Created by Sankar on 22/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "adduTuContactsViewController.h"
#import "ProfileDetailsViewController.h"
#import "AFUser.h"
#import "AppDelegate.h"
#import "CountryListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIFont+uTu.h"

@interface adduTuContactsViewController ()

@end

@implementation adduTuContactsViewController{
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
    
    
    self.messageLabel1.font = [UIFont Museo500Regular13];
    self.messageLabel2.font = [UIFont Museo500Regular13];
    self.countryNameLabel.font = [UIFont Museo700Regular14];
    self.countrystdCodeLabel.font = [UIFont Museo500Regular14];
    self.phoneNumberTextField.font = [UIFont Museo500Regular14];
    self.okLabel.font = [UIFont Museo500Regular14];
    
    self.verificationCodeTextField.font = [UIFont Museo500Regular13];
    
    
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


- (IBAction)okButton:(id)sender {
    
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
    
    if ([self.countryNameLabel.text isEqualToString:@"Select Country"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"Please select a country."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
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
        
        NSString *number = [[self.phoneNumberTextField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
            NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/verify_contact.json?phone_number=%@",number];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
            
            [request setAllHTTPHeaderFields:_headers];
            
            NSURLResponse * response = nil;
            NSError * error = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (error == nil) {
                NSError *_errorJson = nil;
                NSMutableDictionary *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
                //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
                if (![serializesJSONDict objectForKey:@"errors"]) {
                    NSDictionary *contact = [[NSMutableDictionary alloc] init];
                    NSString *idString = [NSString stringWithFormat:@"%d",[[[serializesJSONDict objectForKey:@"user"] objectForKey:@"id"] intValue]];
                    
                    if ([serializesJSONDict objectForKey:@"profile"] && [serializesJSONDict objectForKey:@"profile"] != [NSNull null]) {
                        [contact setValue:[[serializesJSONDict objectForKey:@"profile"] objectForKey:@"username"] forKey:@"name"];
                        [contact setValue:[[serializesJSONDict objectForKey:@"profile"] objectForKey:@"image_url"] forKey:@"image_url"];
                    }else{
                        [contact setValue:@"No Name" forKey:@"name"];
                    }
                    [contact setValue:idString forKey:@"id"];
                    [contact setValue:number forKey:@"number"];
                    //                        [contact setValue:phoneNumber forKey:@"picture"];
                    
                    if (![[AppDelegate user] utuContacts]) {
                        [AppDelegate user].utuContacts = [[NSMutableDictionary alloc] init];
                    }
                    if (![[[AppDelegate user] utuContacts] objectForKey:idString]) {
                        [[[AppDelegate user] utuContacts] setObject:contact forKey:idString];
                        [[AppDelegate user] saveStateInUserDefaults];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Ooops!"
                                          message: @"User not found!"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                if (_errorJson != nil) {
                    NSLog(@"Load Error %@", [_errorJson localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Validation error"
                                          message: @"some thing went wrong"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                } else {
                    NSLog(@"success ");
                    
                }
            } else {
                NSLog(@"Error while getting data");
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"some thing went wrong"
                                      message: [[AppDelegate user] errorInfo]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
            
            
        
        
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",self.countrystdCodeLabel.text,self.phoneNumberTextField.text];
        
        [[AppDelegate user] setPhoneNumer:phoneNumber];
        
        }
                       
}
                       
-(void)dismissKeyboard {
	[self.phoneNumberTextField resignFirstResponder];
	[self.verificationCodeTextField resignFirstResponder];
}


-(void) keyboardDidShow: (NSNotification *)notif
{
//    if (isverifytextField) {
//        if ([UIScreen mainScreen].bounds.size.height == 568) {
//            [UIView animateWithDuration:0.2f animations:^{
//                self.view.center = CGPointMake(self.view.center.x , 240 - 160);
//            }];
//        } else {
//            [UIView animateWithDuration:0.2f animations:^{
//                self.view.center = CGPointMake(self.view.center.x , 240 - 210);
//            }];
//        }
//    }else{
//        if ([UIScreen mainScreen].bounds.size.height == 568) {
//            
//        } else {
//            [UIView animateWithDuration:0.2f animations:^{
//                self.view.center = CGPointMake(self.view.center.x , 240 - 50);
//            }];
//        }
//    }
}

-(void) keyboardWillBeHidden: (NSNotification *)notif
{
//    if ([UIScreen mainScreen].bounds.size.height == 568) {
//        [UIView animateWithDuration:0.1f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 284);
//        }];
//        
//    } else {
//        [UIView animateWithDuration:0.1f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 240);
//        }];
//    }
}

//- (void)becomeInactive:(NSNotification *)notification {
//    [self allFieldsResignResponder];
//}
//
//- (void)allFieldsResignResponder
//{
//    [UIView animateWithDuration:0.5 animations:^
//     {
//         [self.phoneNumberTextField resignFirstResponder];
//     }];
//}


@end
