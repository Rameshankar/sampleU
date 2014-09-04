//
//  TVViewController.m
//  uTu
//
//  Created by Sankar on 17/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "TVViewController.h"
#import "UIFont+uTu.h"
#import "UIImage+animatedGIF.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectYourShowViewController.h"
#import "MainTabBarViewController.h"

@interface TVViewController ()

@end

@implementation TVViewController

@synthesize recognition;

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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
    
//    NSArray *itemArray = [NSArray arrayWithObjects:
//                          [UIImage imageNamed:@"switchleft.png"],
//                          [UIImage imageNamed:@"switchleft.png"],
//                          nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
//    segmentedControl.frame = CGRectMake(100,200,100,40);
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedControl.selectedSegmentIndex = 1;
//    [self.view addSubview:segmentedControl];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"emicon" withExtension:@"gif"];
    self.uTuLogoImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    
    self.turnonTVLabel.font = [UIFont Museo500Regular14];
    
    self.voiceStatusLabel.font = [UIFont Museo500Regular12];
    
    [[[AppDelegate appDelegate] window] addSubview:[[AppDelegate appDelegate] profileView]];
    
    self.turnonTVLabel.text = @"Select your show, press here!";
}

- (void)toggleLabelAlpha {
    
    [self.turnonTVLabel setHidden:(!self.turnonTVLabel.hidden)];
}

- (void) viewWillAppear:(BOOL)animated{
    if ([[AppDelegate user] isShowSelected]) {
        // Hide the tvbutton
        self.voiceStatusLabel.hidden = YES;
        self.tvButton.hidden = YES;
        self.tvImage.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            // set the frame for arrow bottom to emicon
            self.arrowImage.frame = CGRectMake(140, 240, 40, 50);
            // set the frame for trunontvlable bottom to emicon
            self.turnonTVLabel.frame = CGRectMake(20, 310, 280, 18);
            self.turnonTVLabel.text = @"Let's see if your TV is on, press here!";
        });
    }else{
        // show the tvbutton
        self.tvButton.hidden = NO;
        self.tvImage.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            // reset the arrow frame below to tvbutton
            self.arrowImage.frame = CGRectMake(140, 344, 40, 50);
            // reset the frame to turnontvlable below to tvbutton
            self.turnonTVLabel.frame = CGRectMake(20, 392, 280, 18);
            self.turnonTVLabel.text = @"Select your show, press here!";
        });
    }
}

- (void) viewDidLayoutSubviews{
    if ([[AppDelegate user] isShowSelected]) {
        // Hide the tvbutton
        self.voiceStatusLabel.hidden = YES;
        self.tvButton.hidden = YES;
        self.tvImage.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            // set the frame for arrow bottom to emicon
            self.arrowImage.frame = CGRectMake(140, 210, 40, 50);
            // set the frame for trunontvlable bottom to emicon
            self.turnonTVLabel.frame = CGRectMake(20, 260, 280, 18);
            self.turnonTVLabel.text = @"Let's see if your TV is on, press here!";
        });
    }else{
        // show the tvbutton
        self.tvButton.hidden = NO;
        self.tvImage.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            // reset the arrow frame below to tvbutton
            self.arrowImage.frame = CGRectMake(140, 344, 40, 50);
            // reset the frame to turnontvlable below to tvbutton
            self.turnonTVLabel.frame = CGRectMake(20, 392, 280, 18);
            self.turnonTVLabel.text = @"Select your show, press here!";
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tvButton:(id)sender {
    
    [((MainTabBarViewController *)self.parentViewController) setSelectedIndex:0];
    
}

- (IBAction)emiconButton:(id)sender {
//    if ( self != [self.navigationController.viewControllers objectAtIndex:0] )
//    {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle: @"Oops!"
//                              message: @"please select show"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//    }else{
//
//    }
    if ([[AppDelegate user] isShowSelected]) {
//        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.mbHUD.labelText = @"Detecting noice..";
//        self.mbHUD.detailsLabelText = @"Please wait..";
//        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
//        [self.view addSubview:self.mbHUD];
//        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            sleep(10);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.turnonTVLabel.text = @"No noice detected, please try again!";
//                [self.mbHUD setHidden:YES];
//                double delayInSeconds = 0.9;
//                [self.timer invalidate];
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
//                });
//            });
//        });
        self.turnonTVLabel.text = @"";
        recognition = [[ISSpeechRecognition alloc] init];
        
        recognition.freeformType = ISFreeFormTypeDictation;
        
        NSError *err;
        [recognition setDelegate:self];
        
        if(![recognition listenAndRecognizeWithTimeout:5 error:&err]) {
            NSLog(@"ERROR: %@", err);
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops!"
                              message: @"Select your show"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Result: %@", result.text);
    if (result.text && result.text.length > 0) {
//        [[AppDelegate user] setRewardPoints:[NSString stringWithFormat:@"%d",[[[AppDelegate user] rewardPoints] integerValue] + 30]];
//        [AFUser rewardRedeme:@"30" withType:@"Earned" quantitiy:@"" name:@""];
//        [[AppDelegate appDelegate] updateProfileImage];
        self.voiceStatusLabel.hidden = YES;
        [[AppDelegate user] setIsVoiceSuccess:YES];
        [((MainTabBarViewController *)self.parentViewController) setSelectedIndex:0];
        self.turnonTVLabel.text = @"Select your show, press here!";
        [[AppDelegate user] setIsShowSelected:NO];
        [[AppDelegate user] saveStateInUserDefaults];
    }else{
        [self.timer invalidate];
        double delayInSeconds = 2;
        self.voiceStatusLabel.hidden = NO;
        self.voiceStatusLabel.text = @"No noice detected. Let's try again!";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.turnonTVLabel.text = @"Press here!";
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
        });
    }
	
//	[label setText:result.text];
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Error: %@", error);
    [self.timer invalidate];
    double delayInSeconds = 2;
    self.voiceStatusLabel.hidden = NO;
    self.voiceStatusLabel.text = @"No noice detected. Let's try again!";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.turnonTVLabel.text = @"Press here!";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
    });
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    [self.timer invalidate];
    double delayInSeconds = 2;
    self.voiceStatusLabel.hidden = NO;
    self.voiceStatusLabel.text = @"No noice detected. Let's please try again!";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.turnonTVLabel.text = @"Press here!";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(toggleLabelAlpha) userInfo:nil repeats:YES];
    });
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
