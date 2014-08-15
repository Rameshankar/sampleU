//
//  uTuChatViewController.h
//  uTu
//
//  Created by Sankar on 22/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uTuChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contactsContainerView;

- (IBAction)SegmentedControl:(UISegmentedControl *)sender;

@end
