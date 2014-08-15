//
//  SelectYourShowProfileViewController.m
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "SelectYourShowProfileViewController.h"
#import "UIFont+uTu.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FunWithFriendsViewController.h"
#import "TVViewController.h"
#import "ASStarRatingView.h"
#import "MainTabBarViewController.h"
#import "SelectYourShowViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface SelectYourShowProfileViewController () <EKEventEditViewDelegate>

@property (nonatomic, strong) EKCalendar *defaultCalendar;

@end

@implementation SelectYourShowProfileViewController{
    BOOL isfav;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reating:) name:@"Rating" object:nil];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"Select Your Show";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    
    self.yourSelectedLabel.font = [UIFont Museo700Regular14];
    self.ratethisShowLabel.font = [UIFont Museo500Regular11];
    self.remindMeLabel.font = [UIFont Museo500Regular11];
    self.imageTitleLabel.font = [UIFont Museo700Regular14];
    self.eligibleuTuPointsLabel.font = [UIFont Museo500Regular13];
    self.tuneInLabel.font = [UIFont Museo500Regular13];
    self.shareWithFriendsLabel.font = [UIFont Museo500Regular13];
    self.addFavoritesLabel.font = [UIFont Museo500Regular13];
    self.pointsCountLabel.font = [UIFont Museo500Regular13];
    
    int rating = [[self.show objectForKey:@"rating"] intValue];
    if (rating == 1) {
        self.starImage.image = [UIImage imageNamed:@"1stars.png"];
    }else if (rating == 2) {
        self.starImage.image = [UIImage imageNamed:@"2stars.png"];
    }else if (rating == 3) {
        self.starImage.image = [UIImage imageNamed:@"3stars.png"];
    }else if (rating == 4) {
        self.starImage.image = [UIImage imageNamed:@"4stars.png"];
    }else if (rating == 5) {
        self.starImage.image = [UIImage imageNamed:@"5stars.png"];
    }
    
    self.imageTitleLabel.text = [self.show objectForKey:@"show_title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL = [NSString stringWithFormat:@"http://54.255.206.204:3000%@",[self.show objectForKey:@"program_image"]];
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.photoPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
    
//    UITapGestureRecognizer *dimViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuButton:)];
//    [self.tempView addGestureRecognizer:dimViewTapGesture];
//    self.tempView.hidden = YES;
    
    [self checkEventStoreAccessForCalendar];
    
//    self.staticStarRatingView.delegate = self;
    self.staticStarRatingView.canEdit = YES;
}

- (IBAction)menuButton:(id)sender{
    self.tempView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [[AppDelegate appDelegate] updateProfileImage];
    if ([[AppDelegate user] isFav]) {
        self.remindMeView.hidden = NO;
        self.ratethisView.hidden = YES;
    }else{
        self.ratethisView.hidden = NO;
        self.remindMeView.hidden = YES;
    }
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"http://54.255.206.204:3000/is_show_in.json?user_id=%@&show_id=%@",[[AppDelegate user] id],[self.show objectForKey:@"id"]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSDictionary *_headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil];
        
        [request setAllHTTPHeaderFields:_headers];
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error == nil) {
            NSError *_errorJson = nil;
            NSMutableDictionary *serializesJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
            //                    [AppDelegate user].utuContacts = [[NSMutableArray alloc] init];
            if (![serializesJSONDict objectForKey:@"errors"]) {
                if ([[serializesJSONDict objectForKey:@"success"] boolValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        isfav = YES;
                        self.addFavoritesLabel.text = @"Remove from favorites";
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.addFavoritesLabel.text = @"Add to favorites";
                        isfav = NO;
                    });

                }
            }
            if (_errorJson != nil) {
                NSLog(@"Load Error %@", [_errorJson localizedDescription]);
            } else {
                NSLog(@"success ");
                
            }
        } else {
            NSLog(@"Error while getting data");
        }
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateThisShowButton:(id)sender {
    float rating1 = [[[[AppDelegate user] ratings] objectForKey:[NSString stringWithFormat:@"%d",[[self.show objectForKey:@"id"] integerValue]]] floatValue];
    if (rating1) {
        self.staticStarRatingView.rating = rating1;
        [self.staticStarRatingView refreshStar];
        UIAlertView *newAlert = [[UIAlertView alloc]
                                 initWithTitle: @"Info"
                                 message: @"You have already rated this show."
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [newAlert show];
    }else{
        self.tempView.hidden = NO;
    }
}

- (IBAction)tuneInButton:(id)sender {
    [[AppDelegate user] setIsShowSelected:YES];
    [((MainTabBarViewController *)((SelectYourShowViewController *)self.parentViewController).parentViewController) setSelectedIndex:2];
//    self.tvViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TVViewController"];
//    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController pushViewController:self.tvViewController animated:YES];
}

- (IBAction)addFavoritesButton:(id)sender {
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
    
    if (isfav) {
        isfav = NO;
        self.addFavoritesLabel.text = @"Add to favorites";
        [AFUser removeShowFromFav:[self.show objectForKey:@"id"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *newAlert = [[UIAlertView alloc]
                                     initWithTitle: @"Success"
                                     message: @"This show is removed from your favorites."
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [newAlert show];
        });
    }else{
        isfav = YES;
        self.addFavoritesLabel.text = @"Remove from favorites";
        [AFUser addShowToFav:[self.show objectForKey:@"id"]];
    }
}

- (IBAction)shareFriendsButton:(id)sender {
//    [((MainTabBarViewController *)((SelectYourShowViewController *)self.parentViewController).parentViewController) setSelectedIndex:4];
    self.funWithFriendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FunWithFriendsViewController"];
    [self.navigationController pushViewController:self.funWithFriendsViewController animated:YES];
}

- (IBAction)remindMe:(id)sender {
    // Create an instance of EKEventEditViewController
    [[[AppDelegate appDelegate] profileView] removeFromSuperview];
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
	
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
//    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
//     {
//         if (granted)
//         {
//             RootViewController * __weak weakSelf = self;
//             // Let's ensure that our code will be executed from the main queue
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
//                 [weakSelf accessGrantedForCalendar];
//             });
//         }
//     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
//    // Let's get the default calendar associated with our event store
//    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
//    // Enable the Add button
//    self.addButton.enabled = YES;
//    // Fetch all events happening in the next 24 hours and put them into eventsList
//    self.eventsList = [self fetchEvents];
//    // Update the UI with the above events
//    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Fetch events

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
	
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
	// We will only search the default calendar for our events
	NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
    
    // Create the predicate
//	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
//                                                                      endDate:endDate
//                                                                    calendars:calendarArray];
//	
//	// Fetch all events that match the predicate
//	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
	return NO;
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
		  didCompleteWithAction:(EKEventEditViewAction)action
{
    SelectYourShowProfileViewController * __weak weakSelf = self;
	// Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Re-fetch all events happening in the next 24 hours
//                 weakSelf.eventsList = [self fetchEvents];
                 // Update the UI with the above events
//                 [weakSelf.view reloadData];
             });
         }
     }];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
	return self.defaultCalendar;
}

//- (void)rateView:(ASStarRatingView *)rateView ratingDidChange:(float)rating {
//    
//}

- (void) reating:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tempView.hidden = YES;
    });
    NSLog(@"Rating: %f", ((ASStarRatingView *)[notification object]).rating);
    if (![[AppDelegate user] ratings]) {
        [AppDelegate user].ratings = [[NSMutableDictionary alloc] init];
    }
    
    NSString *rating = [NSString stringWithFormat:@"%f",((ASStarRatingView *)[notification object]).rating];
    NSString *showid = [NSString stringWithFormat:@"%d",[[self.show objectForKey:@"id"] integerValue]];
    [[AppDelegate user].ratings setObject:rating forKey:showid];
}


@end
