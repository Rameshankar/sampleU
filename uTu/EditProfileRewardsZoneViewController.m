//
//  RewardsZoneViewController.m
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "EditProfileRewardsZoneViewController.h"
#import "UIFont+uTu.h"
#import "ImagePickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 6
#define CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

@interface EditProfileRewardsZoneViewController ()

@end

@implementation EditProfileRewardsZoneViewController {
     BOOL isImageAdded;
    UIImagePickerController *imagePicker;
    BOOL isDate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector (keyboardDidShow:)
//                                                 name: UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector (keyboardWillBeHidden:)
//                                                 name: UIKeyboardWillHideNotification
//                                               object:nil];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isDate = NO;
//    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Edit Profile";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
//    }
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.firstandlastnameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.statusTextfield setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailTextfield setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.dateofbirthValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.aboutmeValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addressValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.cityValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.stateValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.zipValueTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.firstandlastnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.statusTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.dateofbirthValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.aboutmeValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cityValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.stateValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.zipValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:@"Why does uTu need my Email ID?"];
    [attributeString2 addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString2 length]}];
    self.myEmailLabel.attributedText = [attributeString2 copy];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Why does uTu need my Date of Birth?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.whydateofbirthLabel.attributedText = [attributeString copy];
    
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"Why does uTu need my address?"];
    [attributeString1 addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString1 length]}];
    self.whyaddressLabel.attributedText = [attributeString1 copy];
    
    self.firstandlastnameTextField.font = [UIFont Museo500Regular13];
    self.pointsLabel.font = [UIFont Museo500Regular13];
    self.statusTextfield.font = [UIFont Museo500Regular13];
    self.emailTextfield.font = [UIFont Museo500Regular13];
    self.myEmailLabel.font = [UIFont Museo500Regular11];
    self.dateofbirthLabel.font = [UIFont Museo500Regular13];
    self.dateofbirthValueTextField.font = [UIFont Museo500Regular13];
    self.whydateofbirthLabel.font = [UIFont Museo500Regular11];
    self.aboutMeLabel.font = [UIFont Museo500Regular13];
    self.aboutmeValueTextField.font = [UIFont Museo500Regular13];
    self.addressLabel.font = [UIFont Museo500Regular13];
    self.addressValueTextField.font = [UIFont Museo500Regular13];
    self.whyaddressLabel.font = [UIFont Museo500Regular11];
    self.cityLabel.font = [UIFont Museo500Regular13];
    self.cityValueTextField.font = [UIFont Museo500Regular13];
    self.stateLabel.font = [UIFont Museo500Regular13];
    self.stateValueTextField.font = [UIFont Museo500Regular13];
    self.zipLabel.font = [UIFont Museo500Regular13];
    self.zipValueTextField.font = [UIFont Museo500Regular13];
    self.updateLabel.font = [UIFont Museo500Regular13];
    self.cancelLabel.font = [UIFont Museo500Regular13];
    self.emailAlertLabel1.font = [UIFont Museo500Regular10];
    self.emailAlertLabel2.font = [UIFont Museo500Regular10];
    self.dateofbirthAlertLabel1.font = [UIFont Museo500Regular10];
    self.dateofbirthAlertLabel2.font = [UIFont Museo500Regular10];
    self.myaddressAlertLabel1.font = [UIFont Museo500Regular10];
    self.myaddressAlertLabel2.font = [UIFont Museo500Regular10];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.addressValueTextField.delegate = self;
    self.cityValueTextField.delegate = self;
    self.stateValueTextField.delegate = self;
    self.zipValueTextField.delegate = self;
    
    if ([[AppDelegate user] profilePicture]) {
        self.photoPic.image = [[AppDelegate user] profilePicture];
    } else{
        //        self.photoPic.image = [UIImage imageNamed:@"AppIcon29x29.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoPic setImageWithURL:[NSURL URLWithString:@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQIt0gn1GXEfnSlJtRUWh0r1aVXJYL9X8X1DAcUp1XAUTBSH0yFFA"] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        });
    }
    
    [self loadData];
    
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString * today;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    self.dateofbirthValueTextField.text = strDate;
    today = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *items = [self.dateofbirthValueTextField.text componentsSeparatedByString:@"-"];
    NSArray *items1 = [today componentsSeparatedByString:@"-"];
    
    NSString *selectedDate = [items objectAtIndex:2];
    NSString *todayDate = [items1 objectAtIndex:2];
    
    if ([todayDate integerValue] - [selectedDate integerValue] > 18) {
        isDate = YES;
    }else{
        isDate = NO;
    }
    
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if ([emailTest evaluateWithObject:self.emailTextfield.text] == NO)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"enter the Valid Mail id" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
        [alert show];
        
    }
    return [emailTest evaluateWithObject:email];
}

- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets;
    if (self.navigationItem.rightBarButtonItem) {
        insets = UIEdgeInsetsMake(0, 9.0f, 0, 0);
    }
    else {
    }
    return insets;
}


- (void) loadData{
    if ([[AppDelegate user] username]) {
        self.firstandlastnameTextField.text = [[AppDelegate user] username];
    }else{
        self.firstandlastnameTextField.text = @"";
    }
    
    if ([[AppDelegate user] status]) {
        self.statusTextfield.text = [[AppDelegate user] status];
    }else{
        self.statusTextfield.text = @"";
    }
    
    if ([[AppDelegate user] email]) {
        self.emailTextfield.text = [[AppDelegate user] email];
    }else{
        self.emailTextfield.text = @"";
    }
    
    if ([[AppDelegate user] birthdate]) {
        self.dateofbirthValueTextField.text = [[AppDelegate user] birthdate];
    }else{
        self.dateofbirthValueTextField.text = @"";
    }
    
    if ([[AppDelegate user] aboutme]) {
        self.aboutmeValueTextField.text = [[AppDelegate user] aboutme];
    }else{
        self.aboutmeValueTextField.text = @"";
    }
    
    if ([[AppDelegate user] address]) {
        self.addressValueTextField.text = [[AppDelegate user] address];
    }else{
        self.addressValueTextField.text = @"";
    }
    
    if ([[AppDelegate user] city]) {
        self.cityValueTextField.text = [[AppDelegate user] city];
    }else{
        self.cityValueTextField.text = @"";
    }
    
    if ([[AppDelegate user] state]) {
        self.stateValueTextField.text = [[AppDelegate user] state];
    }else{
        self.stateValueTextField.text = @"";
    }
    
    if ([[AppDelegate user] zip]) {
        self.zipValueTextField.text = [[AppDelegate user] zip];
    }else{
        self.zipValueTextField.text = @"";
    }
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ points",[[AppDelegate user] rewardPoints]];
}

-(void)dismissKeyboard {
	[self.firstandlastnameTextField resignFirstResponder];
	[self.statusTextfield resignFirstResponder];
    [self.emailTextfield resignFirstResponder];
    [self.dateofbirthValueTextField resignFirstResponder];
    [self.aboutmeValueTextField resignFirstResponder];
    [self.addressValueTextField resignFirstResponder];
    [self.cityValueTextField resignFirstResponder];
    [self.stateValueTextField resignFirstResponder];
    [self.zipValueTextField resignFirstResponder];
    self.datePickerView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailButton:(id)sender {
    self.emailAlertView.hidden = NO;
}

- (IBAction)dateofbirthAlertCloseButton:(id)sender {
    self.dateofbirthAlertView.hidden = YES;
}

- (IBAction)mydateofbirthButton:(id)sender {
    self.dateofbirthAlertView.hidden = NO;
}

- (IBAction)myaddressButton:(id)sender {
    self.myaddressAlertView.hidden = NO;
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)photoPic:(id)sender {
    if (isImageAdded) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Picture Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Picture" otherButtonTitles:@"Choose a Picture", @"Take a Picture",nil];
        [action showInView:self.view];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Picture Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose a Picture", @"Take a Picture", nil];
        [action showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 || buttonIndex > 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Take a Picture"]) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [[[AppDelegate appDelegate] profileView] removeFromSuperview];
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
                [[[AppDelegate appDelegate] profileView] removeFromSuperview];
                imagePicker =[[ImagePickerViewController alloc] init];
                imagePicker.delegate = self;
                //                imagePicker.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationLandscapeLeft;
                imagePicker.allowsEditing = YES;
                imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }else if ([title isEqualToString:@"Delete Picture"]){
            self.photoPic.image = nil;
            isImageAdded = NO;
            self.photoPic.image = [UIImage imageNamed:@"roundphoto2.png"];
            
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[AppDelegate appDelegate] updateProfileImage];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIGraphicsBeginImageContextWithOptions(self.photoPic.bounds.size, self.photoPic.opaque, 0.0);
    [self.photoPic.layer renderInContext:UIGraphicsGetCurrentContext()];
    capturedImage = [self imageByScalingAndCroppingForSize:CGSizeMake(107.0, 107.0) withImage:capturedImage];
    self.photoPic.image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.photoPic.image = capturedImage;
    
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

- (IBAction)updateButton:(id)sender {
    NSLog(@"update button");
    
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
    
    if (self.emailTextfield.text.length > 0 && ![self validateEmailWithString:self.emailTextfield.text]) {
        return;
    }
    
    if (self.dateofbirthValueTextField.text.length > 0 && !isDate) {
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Validation"
                                 message: @"Sorry! you are under 18 years old."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
        return;
    }
    
    [[AppDelegate user] setUsername:self.firstandlastnameTextField.text];
    [[AppDelegate user] setStatus:self.statusTextfield.text];
    [[AppDelegate user] setEmail:self.emailTextfield.text];
    [[AppDelegate user] setBirthdate:self.dateofbirthValueTextField.text];
    [[AppDelegate user] setAboutme:self.aboutmeValueTextField.text];
    [[AppDelegate user] setAddress:self.addressValueTextField.text];
    [[AppDelegate user] setCity:self.cityValueTextField.text];
    [[AppDelegate user] setState:self.stateValueTextField.text];
    [[AppDelegate user] setZip:self.zipValueTextField.text];
    [[AppDelegate user] setProfilePicture:self.photoPic.image];
    
    EditProfileRewardsZoneViewController * __weak weakSelf = self;
    
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
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Success"
                                      message: @"Your details updated successfully."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    
    if (sendProfileInfoCompletionBlock) {
        
        self.mbHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.mbHUD.labelText = @"Updating account";
        self.mbHUD.detailsLabelText = @"Updating your details";
        self.mbHUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:self.mbHUD];
        
        [AFUser sendProfileInfoWithCompletionBlock:sendProfileInfoCompletionBlock];
    }
}

- (IBAction)myaddressAlertCloseButton:(id)sender {
    self.myaddressAlertView.hidden = YES;
    self.dateofbirthAlertView.hidden = YES;
}

- (IBAction)emailAlertCloseButton:(id)sender {
    self.emailAlertView.hidden = YES;
}

- (IBAction)dateofBirth:(id)sender {
    self.datePickerView.hidden = NO;
}

- (IBAction)okButton:(id)sender {
    self.datePickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 284 - 40);
        }];
        
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 240 - 100);
        }];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 284 + 20);
        }];
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.view.center = CGPointMake(self.view.center.x , 240 + 20);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


//-(void) keyboardDidShow: (NSNotification *)notif
//{
//    if ([UIScreen mainScreen].bounds.size.height == 568) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 284 - 40);
//        }];
//        
//    } else {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 240 - 88);
//        }];
//    }
//}
//
//-(void) keyboardWillBeHidden: (NSNotification *)notif
//{
//    if ([UIScreen mainScreen].bounds.size.height == 568) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 284);
//        }];
//    } else {
//        [UIView animateWithDuration:0.1f animations:^{
//            self.view.center = CGPointMake(self.view.center.x , 240);
//        }];
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.zipValueTextField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ((([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT))) {
            return YES;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Opps"
                                      message: @"Zip Code is a 6-digit number exclusive"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            });
            return NO;
        }

    }else if (textField == self.cityValueTextField || textField == self.stateValueTextField){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:CHARACTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if ((([string isEqualToString:filtered]))) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;

}


@end
