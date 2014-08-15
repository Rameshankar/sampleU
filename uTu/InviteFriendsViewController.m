//
//  InviteFriendsViewController.m
//  uTu
//
//  Created by Sankar on 19/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LoginViewController.h"
#import "UIFont+uTu.h"
#import "WelcomeViewController.h"
#import "STTwitter.h"
//#import "TwitterConsumer.h"
#import "AppDelegate.h"

@interface InviteFriendsViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;
@end

@implementation InviteFriendsViewController

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
    
    self.addFriendsViaFB.font = [UIFont Museo700Regular14];
    self.addFriendsViaTwitter.font = [UIFont Museo700Regular14];
    self.addFriendsViaSMS.font = [UIFont Museo700Regular14];
    self.addFriendsViaGoogle.font = [UIFont Museo700Regular14];
    self.addFriendsViauTu.font = [UIFont Museo700Regular14];
    
    self.addfriendsEarnPointsLabel.font = [UIFont Museo500Regular10];
    self.yourearnPointsLabel.font = [UIFont Museo500Regular9];
    
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
    UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    nav_titlelbl.text=@"Invite Friends";
    nav_titlelbl.textAlignment=NSTextAlignmentCenter;
    nav_titlelbl.textColor = [UIColor whiteColor];
    nav_titlelbl.font = [UIFont Museo700Regular18];
    self.navigationItem.titleView=nav_titlelbl;
    }
    
//    _consumer = [[TwitterConsumer alloc] initWithKey: @"g5hE50NGluO1njMIGZSxZQH4U" secret: @"oVtOXBw4DFHgdPt4NnWnpWrGzGxCMFLtcc9OGudDARNFTO9yEQ"];
    
	
	NSData* tokenData = [[NSUserDefaults standardUserDefaults] dataForKey: @"Token"];
	if (tokenData != nil)
	{
		_token = (TwitterToken*) [NSKeyedUnarchiver unarchiveObjectWithData: tokenData];
	}

    
}

- (void) viewWillAppear:(BOOL)animated{
    [[AppDelegate appDelegate] updateProfileImage];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addfriendsViaFB:(id)sender {
    [[AppDelegate user] setIsFacebookAuth:TRUE];
    [[AppDelegate user] setIsTwitter:NO];
    self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:self.loginViewController animated:YES];
    
}

- (IBAction)addfriendsViaTwitter:(id)sender {
    [[AppDelegate user] setIsTwitter:YES];
    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
//        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
//        if (self.imageString)
//        {
//            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
//        }
//        
//        if (self.urlString)
//        {
//            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
//        }
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Sorry"
//                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
    
}

- (IBAction)addfriendsViaSMS:(id)sender {
//    [[AppDelegate user] setIsTwitter:NO];
//    ABPeoplePickerNavigationController *picker =
//    [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//    
//    [self presentModalViewController:picker animated:YES];
//    
//    
//    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
//    [_addressBookController setPeoplePickerDelegate:self];
//    [self presentViewController:_addressBookController animated:YES completion:nil];;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self dismissModalViewControllerAnimated:YES];
    
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
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Wellcome to utu...";
                controller.recipients = [NSArray arrayWithObjects:[phoneNumbers objectAtIndex:0], nil];
                controller.messageComposeDelegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }else{
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
            }
        });
        
    }
    
    return YES;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    NSString *trimmedString;
    if (controller.recipients.count > 0) {
        NSString *tempnumber = [[[controller.recipients objectAtIndex:0] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        trimmedString = [tempnumber substringFromIndex:MAX((int)[tempnumber length]-8, 0)];
        //        [AFUser userRequests:trimmedString];
    }
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            [AFUser userRequests:trimmedString];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}

- (IBAction)addfriendsViaGoogle:(id)sender {
    [[AppDelegate user] setIsTwitter:NO];
    [[AppDelegate user] setIsFacebookAuth:FALSE];
    GooglePlusMasterViewController *googlemasterViewController = [[GooglePlusMasterViewController alloc] initWithNibName:@"GooglePlusMasterViewController"
                                                                                                bundle:nil];
    
    [self.navigationController pushViewController:googlemasterViewController animated:YES];
}

- (IBAction)InviteFriendsViauTu:(id)sender {
    [[AppDelegate user] setIsTwitter:NO];
}

//- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
//    
//    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
//        NSLog(@"-- screenName: %@", screenName);
//        
//        _loginStatusLabel.text = screenName;
//        
//        /*
//         At this point, the user can use the API and you can read his access tokens with:
//         
//         _twitter.oauthAccessToken;
//         _twitter.oauthAccessTokenSecret;
//         
//         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
//         
//         Next time, just instanciate STTwitter with the class method:
//         
//         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
//         
//         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
//         */
//        
//    } errorBlock:^(NSError *error) {
//        
//        _loginStatusLabel.text = [error localizedDescription];
//        NSLog(@"-- %@", [error localizedDescription]);
//    }];
//}


@end
