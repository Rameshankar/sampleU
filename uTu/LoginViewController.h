//
//  LoginViewController.h
//  uTu
//
//  Created by Sankar on 05/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController<FBLoginViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *pickFriendsClick;
@property (weak, nonatomic) IBOutlet UIButton *postStatusUpdateClick;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstName;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *pickFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *postStatusUpadateLabel;
@property (weak, nonatomic) IBOutlet UIView *postUpdateView;
@property (weak, nonatomic) IBOutlet UIView *postupdateHeaderView;
@property (weak, nonatomic) IBOutlet UITextView *postUpdateTextView;
@property (weak, nonatomic) IBOutlet UILabel *writeSomethingLabel;
@property (weak, nonatomic) IBOutlet UIView *logoutView;

- (IBAction)loginButton:(id)sender;
- (IBAction)pickFriendsClick:(id)sender;
- (IBAction)postStatusUpdateClick:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)postUpdateButton:(id)sender;

@end
