//
//  FunWithFriendsViewController.m
//  uTu
//
//  Created by Sankar on 11/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "FunWithFriendsViewController.h"
#import "UIFont+uTu.h"
#import "uTuFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"

@interface FunWithFriendsViewController ()

@end

@implementation FunWithFriendsViewController

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
    
    self.inviteFriendsLabel.font = [UIFont Museo700Regular14];
    self.chatWithFriendsLabel.font = [UIFont Museo700Regular14];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Fun with Friends";
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

- (IBAction)inviteFriends:(id)sender {
//    UIAlertView* alert_view = [[UIAlertView alloc]
//                               initWithTitle: @"" message: @"uTu Would Like To Access Your Contacts" delegate: self
//                               cancelButtonTitle: @"Don't Allow" otherButtonTitles: @"OK", nil];
//    [alert_view show];
    self.uTufriendsviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uTuChatViewController"];
    [self.navigationController pushViewController:self.uTufriendsviewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    NSLog(@"clicking");
    if (buttonIndex == 0)
    {
        NSLog(@"ok");
        
    }
    else
    {
        NSLog(@"cancel");
//        [[AppDelegate user] setIsTwitter:NO];
//        ABPeoplePickerNavigationController *picker =
//        [[ABPeoplePickerNavigationController alloc] init];
//        picker.peoplePickerDelegate = self;
//        
//        [self presentModalViewController:picker animated:YES];
//        
//        
//        _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
//        [_addressBookController setPeoplePickerDelegate:self];
//        [self presentViewController:_addressBookController animated:YES completion:nil];;
        
        self.uTufriendsviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uTuChatViewController"];
        [self.navigationController pushViewController:self.uTufriendsviewController animated:YES];
    }
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for ( int32_t propertyIndex = kABPersonFirstNameProperty; propertyIndex <= kABPersonSocialProfileProperty; propertyIndex ++ )
    {
        NSString* propertyName = CFBridgingRelease(ABPersonCopyLocalizedPropertyName(propertyIndex));
        id value = CFBridgingRelease(ABRecordCopyValue(person, propertyIndex));
        
        if ( value )
            [dictionary setObject:value forKey:propertyName];
    }
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    ABMultiValueRef multiPhones = ABRecordCopyValue(person,kABPersonPhoneProperty);
    for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);++i) {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
        NSString *phoneNumber = (NSString *) CFBridgingRelease(phoneNumberRef);
        
        [phoneNumbers addObject:phoneNumber];
    }
    NSLog(@"person name%@",phoneNumbers);
    NSLog(@"person name%@",dictionary);
    NSLog(@"phone %@",[dictionary objectForKey:@"Phone"]);
    
    //    [self displayPerson:person];
    //    [self dismissModalViewControllerAnimated:YES];
    
    if (phoneNumbers.count > 0) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"Wellcome to utu...";
            controller.recipients = [NSArray arrayWithObjects:[phoneNumbers objectAtIndex:0], nil];
            //		controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
//    self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
//    self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}


- (IBAction)chatWithFriends:(id)sender {

//    UIAlertView *newAlert = [[UIAlertView alloc]
//                             initWithTitle: @""
//                             message: @"uTu Would Like To Access Your Contacts"
//                             delegate:self
//                             cancelButtonTitle:@"Don't Allow"
//                             otherButtonTitles:@"Ok",nil];
//    [newAlert show];
    self.uTufriendsviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"uTuChatViewController"];
    [self.navigationController pushViewController:self.uTufriendsviewController animated:YES];
}

@end
