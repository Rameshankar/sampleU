//
//  ImagePickerViewController.m
//  Ola Mundo
//
//  Created by Sankar Dheksit on 4/26/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]){
//        return UIInterfaceOrientationMaskLandscape;
//    }else{
        return UIInterfaceOrientationMaskPortrait;
//    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

@end
