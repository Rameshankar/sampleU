//
//  ProfileDetailsViewController.m
//  uTu
//
//  Created by Sankar on 12/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "ProfileDetailsViewController.h"
#import "ImagePickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AppDelegate.h"
#import "UIFont+uTu.h"
#import "User.h"

@interface ProfileDetailsViewController ()

@end

@implementation ProfileDetailsViewController{
    UIImagePickerController *imagePicker;
    UIActivityIndicatorView *spinner;
    BOOL isImageAdded;
    BOOL keyboardGoingDown;
    BOOL isQKBOpen;
}

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
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.nextLabel.attributedText = [attributeString copy];
    self.nextLabel.font = [UIFont Museo500Regular14];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.userNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.delegate = self;
    
    self.addphotoImageView.layer.cornerRadius = 12;
    self.addphotoImageView.clipsToBounds = YES;
    
    self.profileDetailsLabel.font = [UIFont Museo700Regular14];
    self.yourNameLabel.font = [UIFont Museo500Regular13];
//    self.userNameTextField.font = [UIFont Museo500Regular14];
    self.includeuTuLabel.font = [UIFont Museo500Regular13];
    
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        self.userNameTextField.font = [UIFont Museo500Regular13];
    }else{
        self.userNameTextField.font = [UIFont Museo500Regular15];

    }
    
}

-(void)dismissKeyboard {
	[self.userNameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addphotoButton:(id)sender {
    
    if (isImageAdded) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Picture Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Picture" otherButtonTitles:@"Choose a Picture", @"Take a Picture",nil];
        [action showInView:self.view];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Picture Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose a Picture", @"Take a Picture", nil];
        [action showInView:self.view];
    }
}

- (IBAction)nextButton:(id)sender {
    
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
    
//    if (!isImageAdded ) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle: @"Validation error"
//                              message: @"Image can not be blank"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (self.userNameTextField.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Validation error"
                              message: @"username can not be blank"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[AppDelegate user] setUsername:self.userNameTextField.text];
    [[AppDelegate user] setProfilePicture:self.addphotoImageView.image];
    
    ProfileDetailsViewController * __weak weakSelf = self;
    
    void(^sendProfileInfoCompletionBlock)(NSError *error) = ^void(NSError *error)
    {
        // hide the mbHud
        [self.mbHUD setHidden:YES];
        if (error) {
            NSLog(@"error %@",error);
            //show server error message. username is already taken
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Server Error"
                                  message: @"username is already taken"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            if ([[AppDelegate user] errorInfo]) {
                // show error message
            }else{
                //redirect view
                [[AppDelegate user] saveStateInUserDefaults];
                self.mainTabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                [self.navigationController pushViewController:self.mainTabBarViewController animated:YES];
            }
        }
    };
    
    if (sendProfileInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Validating account";
        self.mbHUD.detailsLabelText = @"photo and username are being checked";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser sendProfileInfoWithCompletionBlock:sendProfileInfoCompletionBlock];
    }
}

- (IBAction)qwertyKeyboard:(id)sender {
    [self.userNameTextField becomeFirstResponder];
//    if (isQKBOpen) {
//        self.qwertyKeyboard.transform = CGAffineTransformMakeRotation(0);
//    }else{
//        self.qwertyKeyboard.transform = CGAffineTransformMakeRotation(M_PI);
//    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    isQKBOpen = YES;
    self.qwertyKeyboard.transform = CGAffineTransformMakeRotation(M_PI);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to
{
    isQKBOpen = NO;
    self.qwertyKeyboard.transform = CGAffineTransformMakeRotation(0);
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.userNameTextField resignFirstResponder];
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 || buttonIndex > 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Take a Picture"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker =[[ImagePickerViewController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                          (NSString *) kUTTypeImage,
                                          nil];
                imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                //                self.cameraPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                //                CGRect rect;
                //                rect = CGRectMake(self.view.center.x,self.view.center.y - 160,1,1);
                //                [self.cameraPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
            }
            else
            {
                
                UIAlertView *newAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Camera failed to open"
                                         message: @"Camera is not available"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
                [newAlert show];
                
            }
        }else if ([title isEqualToString:@"Choose a Picture"]){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imagePicker =[[ImagePickerViewController alloc] init];
                imagePicker.delegate = self;
                //                imagePicker.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationLandscapeLeft;
                imagePicker.allowsEditing = YES;
                imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }else if ([title isEqualToString:@"Delete Picture"]){
            self.addphotoImageView.image = nil;
            isImageAdded = NO;
            self.addphotoImageView.image = [UIImage imageNamed:@"roundphoto2.png"];
            
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIGraphicsBeginImageContextWithOptions(self.addphotoImageView.bounds.size, self.addphotoImageView.opaque, 0.0);
    [self.addphotoImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    capturedImage = [self imageByScalingAndCroppingForSize:CGSizeMake(107.0, 107.0) withImage:capturedImage];
    self.addphotoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.addphotoImageView.image = capturedImage;
    
    isImageAdded = YES;
//    tempImageData = UIImageJPEGRepresentation( capturedImage , 1.0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        [self.cameraPopoverController dismissPopoverAnimated:YES];
    });
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
