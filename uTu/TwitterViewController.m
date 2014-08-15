//
//  TwitterViewController.m
//  uTu
//
//  Created by Sankar on 15/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "TwitterViewController.h"
#import "STTwitterAPI.h"
#import "UIFont+uTu.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface TwitterViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;
@end

@implementation TwitterViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterCallback:) name:@"TwitterCallback" object:nil];
    
    self.loginStatusLabel.font = [UIFont Museo700Regular14];
    self.loginTwitterLabel.font = [UIFont Museo700Regular16];
    self.welcomeLabel.font = [UIFont Museo700Regular22];
    self.pickFriendsLabel.font = [UIFont Museo700Regular14];
    self.postTwitterLabel.font = [UIFont Museo700Regular14];
    self.tweetLable.font = [UIFont Museo700Regular14];
    
    self.twitterPicture.layer.cornerRadius = 14.0;
    self.twitterPicture.layer.masksToBounds = YES;
    
    if ([AppDelegate twitter]) {
        self.twitter = [AppDelegate twitter];
        self.postTwitterLabel.text = @"Logout";
        self.welcomeLabel.text = @"Welcome";
        self.loginTwitterLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterUsername"];;
        self.postButton.hidden = NO;
        self.tweetLable.hidden = NO;
    }else{
        self.loginTwitterLabel.text = @"";
        self.postTwitterLabel.text = @"Login with Twitter";
        self.welcomeLabel.text = @"";
        self.postButton.hidden = YES;
        self.tweetLable.hidden = YES;
    }
    
    UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    nav_titlelbl.text=@"Twitter";
    nav_titlelbl.textAlignment=NSTextAlignmentCenter;
    nav_titlelbl.textColor = [UIColor whiteColor];
    nav_titlelbl.font = [UIFont Museo700Regular18];
    self.navigationItem.titleView=nav_titlelbl;
    
//    NSDictionary *keys = [[NSUserDefaults standardUserDefaults] objectForKey:@"Twitterkeys"];
    
//    if (keys) {
//        self.postTwitterLabel.text = @"Logout";
//        NSString *token = keys[@"oauth_token"];
//        NSString *verifier = keys[@"oauth_verifier"];
//        self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"g5hE50NGluO1njMIGZSxZQH4U" consumerSecret:@"oVtOXBw4DFHgdPt4NnWnpWrGzGxCMFLtcc9OGudDARNFTO9yEQ" oauthToken:token oauthTokenSecret:verifier];
//        [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
//            
//            self.loginTwitterLabel.text = username;
//            
//        } errorBlock:^(NSError *error) {
//            self.twitter = nil;
//            self.postTwitterLabel.text = @"Login with Twitter";
////            _loginStatusLabel.text = [error localizedDescription];
//        }];
//        
//        [self setOAuthToken:token oauthVerifier:verifier];
//    }else{
//        self.postTwitterLabel.text = @"Login with Twitter";
//    }
    
    [self.textView setDelegate:self];
}

- (void) twitterCallback:(NSNotification *) notification{
    NSLog(@"notifcation object %@", [notification object]);
    NSDictionary *d = [notification object];
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    if (d) {
        [[NSUserDefaults standardUserDefaults] setObject:d  forKey:@"Twitterkeys"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self setOAuthToken:token oauthVerifier:verifier];
}

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"viewwillappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TwitterButton:(id)sender {
    
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
    
    if (self.twitter) {
        self.postTwitterLabel.text = @"Login with Twitter";
        self.twitter = nil;
        self.loginTwitterLabel.text = @"";
        self.welcomeLabel.text = @"";
        self.postButton.hidden = YES;
        self.tweetLable.hidden = YES;
        [[AppDelegate appDelegate] setTwitter:nil];
    }else{
        self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"g5hE50NGluO1njMIGZSxZQH4U"
                                                     consumerSecret:@"oVtOXBw4DFHgdPt4NnWnpWrGzGxCMFLtcc9OGudDARNFTO9yEQ"];
        
        
        [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            NSLog(@"-- url: %@", url);
            NSLog(@"-- oauthToken: %@", oauthToken);
            
            [[UIApplication sharedApplication] openURL:url];
        } forceLogin:@(YES)
                        screenName:nil
                     oauthCallback:@"myapp://twitter_access_tokens/"
                        errorBlock:^(NSError *error) {
                            NSLog(@"-- error: %@", error);
                            _loginStatusLabel.text = [error localizedDescription];
                        }];
    }
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        self.postTwitterLabel.text = @"Logout";
        self.loginTwitterLabel.text = screenName;
        self.welcomeLabel.text = @"Welcome";
        
        self.postButton.hidden = NO;
        self.tweetLable.hidden = NO;

        [[NSUserDefaults standardUserDefaults] setObject:screenName  forKey:@"TwitterUsername"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AppDelegate appDelegate] setTwitter:self.twitter];
        /*
         At this point, the user can use the API and you can read his access tokens with:
         
         _twitter.oauthAccessToken;
         _twitter.oauthAccessTokenSecret;
         
         You can store these tokens (in user default, or in keychain) so that the user doesn't need to authenticate again on next launches.
         
         Next time, just instanciate STTwitter with the class method:
         
         +[STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerSecret:oauthToken:oauthTokenSecret:]
         
         Don't forget to call the -[STTwitter verifyCredentialsWithSuccessBlock:errorBlock:] after that.
         */
        
    } errorBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops.."
                              message: @"Please try again"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        _loginStatusLabel.text = [error localizedDescription];
        NSLog(@"-- %@", [error localizedDescription]);
    }];

    
}

- (IBAction)sendButton:(id)sender {
    if (self.textView.text.length > 0) {
        @try {
            [_twitter postStatusUpdate:self.textView.text inReplyToStatusID:Nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:nil successBlock:nil errorBlock:^(NSError *error) {
                self.postView.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Sorrt.."
                                      message: @"Please try again"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                _loginStatusLabel.text = [error localizedDescription];
                NSLog(@"-- %@", [error localizedDescription]);
            }];
            self.postView.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Success!"
                                  message: @"Your tweet was successfully posted"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        @catch (NSException *exception) {
            NSLog(@"exception");
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTwitterTVCellIdentifier"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"STTwitterTVCellIdentifier"];
    }
    
    NSDictionary *status = [self.statuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}

- (IBAction)postButtonClick:(id)sender {
    self.textView.text = @"";
    self.postView.hidden = NO;
}

- (IBAction)cancelButton:(id)sender {
    [self.textView resignFirstResponder];
    self.postView.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textView isFirstResponder] && [touch view] != self.textView) {
        [self.textView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
