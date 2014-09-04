//
//  TVViewController.h
//  uTu
//
//  Created by Sankar on 17/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYourShowViewController.h"
#import "MBProgressHUD.h"
#import "ISpeechSDK.h"

@interface TVViewController : UIViewController <ISSpeechRecognitionDelegate>

@property (nonatomic, strong) ISSpeechRecognition *recognition;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *turnonTVLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uTuLogoImage;
@property (weak, nonatomic) IBOutlet UIButton *tvButton;
@property (strong, nonatomic) SelectYourShowViewController *selectYourShowViewController;
@property (weak, nonatomic) IBOutlet UIButton *emiconButton;
@property (weak, nonatomic) IBOutlet UILabel *voiceStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *tvImage;

- (IBAction)tvButton:(id)sender;
- (IBAction)emiconButton:(id)sender;

@property (nonatomic, strong) MBProgressHUD *mbHUD;
@property (strong, nonatomic) NSTimer *timer;

@end
