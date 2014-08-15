//
//  ViewController.m
//  uTu
//
//  Created by Sankar on 25/03/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "ViewController.h"
#import "UIFont+uTu.h"

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if([[UIScreen mainScreen]bounds].size.height == 568)
    {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"doublecolor1.png"]];
    }
    else
    {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"doublecolor1.png"]];
    }
    
    self.registerButton.layer.cornerRadius = 6;
    self.registerButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth=1.0f;
    
    self.label.font = [UIFont Museo500Regular20];
    self.headerText.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
