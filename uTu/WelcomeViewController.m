//
//  WelcomeViewController.m
//  uTu
//
//  Created by Sankar on 17/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "ProfileDetailsViewController.h"
#import "MainTabBarViewController.h"
#import "UIImage+animatedGIF.h"
#import "UIFont+uTu.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[AppDelegate user] phoneNumer]) {
        if (![[AppDelegate user] isLoggedIn]) {
            //render profile view controller
            self.verifyPhoneNumberViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneNumberViewController"];
            [self.navigationController pushViewController:self.verifyPhoneNumberViewController animated:YES];
        }else{
            // tab veiw cotroller
            self.mainTabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
            [self.navigationController pushViewController:self.mainTabBarViewController animated:YES];
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Terms and conditions"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.termsLabel.attributedText = [attributeString copy];
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"emicon" withExtension:@"gif"];
    self.uTuLogoImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    self.welcomeLabel.font = [UIFont Museo700Regular24];
    self.messageLabel.font = [UIFont Museo500Regular14];
    self.termsLabel.font = [UIFont Museo500Regular12];
    self.agreeLabel.font = [UIFont Museo500Regular14];
    
    self.registerheaderLabel.font = [UIFont Museo500Regular12];
    self.registerViewText.font = [UIFont Museo500Regular10];
    
    self.termsHeaderLabel.font = [UIFont Museo500Regular12];
    self.termsBodyLabel.font = [UIFont Museo500Regular10];
    
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"Why Should I Register?"];
    [attributeString1 addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:1]
                             range:(NSRange){0,[attributeString1 length]}];
    self.registerLabel.attributedText = [attributeString1 copy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeButton:(id)sender {
}

- (IBAction)registerButton:(id)sender {
    self.registerView.hidden = NO;
}

- (IBAction)close:(id)sender{
    self.registerView.hidden = YES;
    
}

- (IBAction)termsCloseButton:(id)sender {
    self.termsAlertView.hidden = YES;
}

- (IBAction)termsandConditionsButton:(id)sender {
    self.termsAlertView.hidden = NO;
}

@end
