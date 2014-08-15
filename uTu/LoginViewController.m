//
//  LoginViewController.m
//  uTu
//
//  Created by Sankar on 05/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBMembersViewController.h"
#import "UIFont+uTu.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface LoginViewController () <FBLoginViewDelegate>
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;

@end

@implementation LoginViewController

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
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes",@"user_friends",@"public_profile",@"contact_email"]];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 100);
    
    self.profilePic.hidden = YES;
    self.postStatusUpadateLabel.hidden = YES;
    self.postStatusUpdateClick.hidden = YES;
    
    loginView.frame = CGRectMake(0, 0, 240, 40);
    for (id obj in loginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"yellowImage.png"];
            loginView.layer.cornerRadius = 10;
            loginView.clipsToBounds = YES;
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
//            loginLabel.text = @"Log in to facebook";
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 240, 40);
            loginLabel.textColor = [UIColor colorWithRed:(95/255.f) green:(13/255.f) blue:(62/255.f) alpha:1.0f];
            loginLabel.font = [UIFont Museo700Regular14];
        }
    }
    
    loginView.delegate = self;
    [self.logoutView addSubview:loginView];
    
    self.pickFriendsLabel.font = [UIFont Museo700Regular14];
//    self.postStatusUpadateLabel.font = [UIFont Museo700Regular14];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
    UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    nav_titlelbl.text=@"Facebook";
    nav_titlelbl.textAlignment=NSTextAlignmentCenter;
    nav_titlelbl.textColor = [UIColor whiteColor];
    nav_titlelbl.font = [UIFont Museo700Regular18];
    self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.profilePic.layer.cornerRadius = 14.0;
    self.profilePic.layer.masksToBounds = YES;
    
    [self.postUpdateTextView setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 100);
//    [self.view addSubview:loginView];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"infor %@",user);
    
    self.profilePic.hidden = NO;
    self.postStatusUpadateLabel.hidden = NO;
    self.postStatusUpdateClick.hidden = NO;
    
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    self.labelFirstName.font = [UIFont Museo700Regular14];
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.username];
    [self.profilePic setImageWithURL:[NSURL URLWithString:userImageURL] placeholderImage:[UIImage imageNamed:@"profilePictureImage.png"]];
//    self.profilePic.profileID = user.id;
    self.loggedInUser = user;

//        int i = 0;
//        for (NSDictionary<FBGraphUser>* friend in friends) {
//            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//            if (i == 0) {
//                FBRequest* friendsRequest1 = [FBRequest requestWithGraphPath:[NSString stringWithFormat:@"%@/feed",friend.id] parameters:params HTTPMethod:@"POST"];
//                [self performPublishAction:^{
//                    [friendsRequest1 startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                                   NSDictionary* result,
//                                                                   NSError *error) {
//                        NSLog(@"Found: %@ error %@", result , error);
//                    }];
//                }];
//            }
//            i++;
//        }
////        NSArray *friendIDs = [friends collect:^id(NSDictionary<FBGraphUser>* friend) {
////            return friend.id;
////        }];
//        
//    }];
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.postStatusUpdateClick.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    [self.postStatusUpdateClick setTitle:@"Post An Update" forState:self.postStatusUpdateClick.state];
    self.postStatusUpdateClick.font = [UIFont Museo700Regular14];
    
//    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
}

//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    // here we use helper properties of FBGraphUser to dot-through to first_name and
//    // id properties of the json response from the server; alternatively we could use
//    // NSDictionary methods such as objectForKey to get values from the my json object
//    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
//    // setting the profileID property of the FBProfilePictureView instance
//    // causes the control to fetch and display the profile picture for the user
////    self.profilePic.profileID = user.id;
//    self.loggedInUser = user;
//}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    self.postStatusUpdateClick.enabled = canShareFB || canShareiOS6;
    self.postStatusUpdateClick.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
//    [self.postStatusUpdateClick setTitle:@"Post An Update" forState:self.postStatusUpdateClick.state];
    self.postStatusUpdateClick.font = [UIFont Museo700Regular14];
    
//    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
    
    self.profilePic.hidden = YES;
    self.postStatusUpadateLabel.hidden = YES;
    self.postStatusUpdateClick.hidden = YES;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    self.postUpdateTextView.text = @"";
    self.postUpdateView.hidden = NO;
    self.writeSomethingLabel.hidden = NO;
}

- (IBAction)cancelButton:(id)sender {
    [self.postUpdateTextView resignFirstResponder];
    self.postUpdateView.hidden = YES;
}

- (IBAction)postUpdateButton:(id)sender {
    
    if (self.postUpdateTextView.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Ooops!"
                              message: @"Text should not be empty."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"Hello Facebook"
                                                       caption:nil
                                                   description:@"The 'Hello Facebook' utu application showcases."
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:nil
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"uTu app", @"name",
                                               @"http://utu.mobi/", @"link",
                                               @"uTu app for iPhone!", @"caption",
                                               @"", @"description",
                                               self.postUpdateTextView.text, @"message",
                                               nil];
                
                // Publish.
                // This is the most important method that you call. It does the actual job, the message posting.
                
                //    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=email,name,picture,id" parameters:nil HTTPMethod:@"GET"];
                //    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                //                                                  NSDictionary* result,
                //                                                  NSError *error) {
                //        NSArray* friends = [result objectForKey:@"data"];
                //        NSLog(@"Found: %lu friends", (unsigned long)friends.count);
                //
                FBRequest* friendsRequest1 = [FBRequest requestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"];
                [friendsRequest1 startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                               NSDictionary* result,
                                                               NSError *error) {
                    NSLog(@"Found: %@ error %@", result , error);
                    [self showAlert:@"" result:result error:error];
                    [self cancelButton:Nil];
                }];
                
//                NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];
//                
//                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
//                
//                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
//                | FBRequestConnectionErrorBehaviorAlertUser
//                | FBRequestConnectionErrorBehaviorRetry;
//                
//                [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
//                     completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
//                         [self showAlert:message result:result error:error];
//                         self.postStatusUpdateClick.enabled = YES;
//                     }];
//                [connection start];
                
//                self.postStatusUpdateClick.enabled = NO;
                
            }];
        }
    }

}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender {
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
//        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted your message."];
//        NSString *postId = [resultDict valueForKey:@"id"];
//        if (!postId) {
//            postId = [resultDict valueForKey:@"postId"];
//        }
//        if (postId) {
//            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
//        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.writeSomethingLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.writeSomethingLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.writeSomethingLabel.hidden = ([txtView.text length] > 0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postUpdateTextView isFirstResponder] && [touch view] != self.postUpdateTextView) {
        [self.postUpdateTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
