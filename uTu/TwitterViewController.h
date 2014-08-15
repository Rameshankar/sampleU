//
//  TwitterViewController.h
//  uTu
//
//  Created by Sankar on 15/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginTwitterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *twitterPicture;
@property (weak, nonatomic) IBOutlet UILabel *pickFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTwitterLabel;
@property (nonatomic, strong) NSArray *statuses;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLable;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UILabel * defaultLabel;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

- (IBAction)sendButton:(id)sender;
- (IBAction)TwitterButton:(id)sender;
- (IBAction)PickFriends:(id)sender;
- (IBAction)PostTwitter:(id)sender;
- (IBAction)postButtonClick:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
