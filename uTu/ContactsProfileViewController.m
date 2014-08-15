//
//  ContactsProfileViewController.m
//  uTu
//
//  Created by Sankar on 16/07/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "ContactsProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIFont+uTu.h"


@interface ContactsProfileViewController ()

@end

@implementation ContactsProfileViewController

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
    
    self.pointsLabel.font = [UIFont Museo500Regular14];
    self.dateofbirthLabel.font = [UIFont Museo500Regular14];
    self.dateofbirthValueLabel.font = [UIFont Museo500Regular13];
    self.addressLabel.font = [UIFont Museo500Regular14];
    self.addressValueLabel.font = [UIFont Museo500Regular13];
    self.aboutmeLabel.font = [UIFont Museo500Regular14];
    self.aboutmeValueLabel.font = [UIFont Museo500Regular13];
    self.emailLabel.font = [UIFont Museo500Regular14];
    self.statusLabel.font = [UIFont Museo500Regular13];
    self.firstNameLabel.font = [UIFont Museo500Regular14];
    self.cancelLabel.font = [UIFont Museo500Regular13];

}

- (void) viewWillAppear:(BOOL)animated{
    [self.photoPic setImageWithURL:[NSURL URLWithString:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA"] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
    void(^getContactInfoCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        [self.mbHUD setHidden:YES];
        if (error) {
            NSLog(@"error %@",error);
            //show server error message. username is already taken
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"Please check your internet connection"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUIElements];
            });
        }
    };
    
    if (getContactInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Please wait";
        self.mbHUD.detailsLabelText = @"Loading data";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser getContactProfileWithCompletionBlock:getContactInfoCompletionBlock];
    }
}

- (void) updateUIElements{
    NSLog(@"contact profile %@",[[AppDelegate user] contactProfile]);
    NSMutableDictionary *contactProfile = [[AppDelegate user] contactProfile];
    if ([[contactProfile objectForKey:@"user"] objectForKey:@"reward_points"] && [[contactProfile objectForKey:@"user"] objectForKey:@"reward_points"] != [NSNull null]) {
        NSString *reward_points = [NSString stringWithFormat:@"%@ points", [[contactProfile objectForKey:@"user"] objectForKey:@"reward_points"]];
        self.pointsLabel.text = reward_points;
    }else{
        self.pointsLabel.text = @"";
    }
    if ([contactProfile objectForKey:@"profile"] && [contactProfile objectForKey:@"profile"] != [NSNull null]) {
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"username"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"username"] != [NSNull null]) {
            self.firstNameLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"username"];
        }else{
            self.firstNameLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"status"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"status"] != [NSNull null]) {
            self.statusLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"status"];
        }else{
            self.statusLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"email"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"email"] != [NSNull null]) {
            self.emailLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"email"];
        }else{
            self.emailLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"date_of_birth"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"date_of_birth"] != [NSNull null]) {
            self.dateofbirthValueLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"date_of_birth"];
        }else{
            self.dateofbirthValueLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"about_me"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"about_me"] != [NSNull null]) {
            self.aboutmeValueLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"about_me"];
        }else{
            self.aboutmeValueLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"address"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"address"] != [NSNull null]) {
            self.addressValueLabel.text = [[contactProfile objectForKey:@"profile"] objectForKey:@"address"];
        }else{
            self.addressValueLabel.text = @"";
        }
        
        if ([[contactProfile objectForKey:@"profile"] objectForKey:@"image_url"] && [[contactProfile objectForKey:@"profile"] objectForKey:@"image_url"] != [NSNull null]) {
            self.photoPic.image = [[AppDelegate user] profilePicture];
            [self.photoPic setImageWithURL:[NSURL URLWithString:[[contactProfile objectForKey:@"profile"] objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        } else{
            //        self.photoPic.image = [UIImage imageNamed:@"AppIcon29x29.png"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photoPic setImageWithURL:[NSURL URLWithString:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA"] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
            });
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
