//
//  uTuFriendsViewController.m
//  uTu
//
//  Created by Sankar on 21/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "uTuFriendsViewController.h"
#import "uTuFriendsCell.h"
#import "UIFont+uTu.h"
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface uTuFriendsViewController ()
@property (nonatomic, strong) NSArray *akeys;
@end

@implementation uTuFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFriendsView) name:@"reloadFriendsView" object:Nil];
    
    if([[[UIDevice currentDevice] systemVersion] hasPrefix: @"7"]){
        UILabel *nav_titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
        nav_titlelbl.text=@"uTu Friends";
        nav_titlelbl.textAlignment=NSTextAlignmentCenter;
        nav_titlelbl.textColor = [UIColor whiteColor];
        nav_titlelbl.font = [UIFont Museo700Regular18];
        self.navigationItem.titleView=nav_titlelbl;
    }
    //    NSLog(@"utucontacts %@", [[AppDelegate user] temputuContacts]);
    self.akeys = [[NSArray alloc] init];
    if ([[[AppDelegate user] temputuContacts] count] > 0) {
        self.akeys = [[[AppDelegate user] temputuContacts] allKeys];
    }
    
    //    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain
    //                                                                     target:self action:@selector(refreshPropertyList:)];
    //    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
}

- (void) reloadFriendsView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.akeys = [[NSArray alloc] init];
        if ([[[AppDelegate user] temputuContacts] count] > 0) {
            self.akeys = [[[AppDelegate user] temputuContacts] allKeys];
        }
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.akeys = [[NSArray alloc] init];
        if ([[[AppDelegate user] temputuContacts] count] > 0) {
            self.akeys = [[[AppDelegate user] temputuContacts] allKeys];
        }
        [self.tableView reloadData];
    });
}

//- (IBAction)refreshPropertyList:(id)sender {
//    NSLog(@"add button");
//    self.addContactView.hidden = NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppDelegate user] temputuContacts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    uTuFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *key = [self.akeys objectAtIndex:indexPath.row];
    
    NSDictionary *contact = [[[AppDelegate user] temputuContacts] objectForKey:key];
    
    //    NSLog(@"count:: %@", [contact objectForKey:@"count"]);
    if ([[contact objectForKey:@"count"] intValue] != 0) {
        cell.countLabel.hidden = NO;
        cell.countLabel.text = [contact objectForKey:@"count"];
    }else{
        cell.countLabel.hidden = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *imageURL = [contact objectForKey:@"image_url"];
        if (imageURL){
            imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.contactPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ola-mundo-icon.png"]];
        }
    });
    
    cell.contactName.font = [UIFont Museo700Regular14];
    cell.contactNumber.font = [UIFont Museo700Regular12];
    
    cell.contactName.text = [contact objectForKey:@"name"];
    if ([contact objectForKey:@"status"] && [contact objectForKey:@"status"] != [NSNull null] && ![[contact objectForKey:@"status"] isEqualToString:@""]) {
        cell.contactNumber.text = [contact objectForKey:@"status"];
    }else{
        cell.contactNumber.text = [contact objectForKey:@"number"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.akeys objectAtIndex:indexPath.row];
    
    NSMutableDictionary *contact = [[[AppDelegate user] temputuContacts] objectForKey:key];
    
    NSMutableArray *contcmessages = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (contcmessages) {
        [[AppDelegate user] setContactMessages:contcmessages];
    }else{
        [AppDelegate user].contactMessages = [[NSMutableArray alloc] init];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate user].contactMessages  forKey:key];
    
    [[AppDelegate user] setContactId:key];
    NSLog(@"contact id%@",[[AppDelegate user] contactId]);
    
    // allcate the chatviewcontroller
}

//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    //[picker setDelegate:self];
//    picker.mailComposeDelegate = self;
//    //[picker setToRecipients:recipients];
//    [picker setSubject:@"uTu"];
//    [picker setMessageBody:@"message body" isHTML:YES];
//    [self presentViewController:picker animated:YES completion:nil];
//}
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller
//          didFinishWithResult:(MFMailComposeResult)result
//                        error:(NSError*)error
//{
//    if(error) NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
//    [self dismissViewControllerAnimated:YES completion:nil];
//    return;
//}
//
//- (void) closeMessage {
//
//    [self dismissViewControllerAnimated:NO completion:nil];
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
