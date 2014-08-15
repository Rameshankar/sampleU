//
//  LocalContactsViewController.m
//  uTu
//
//  Created by Sankar on 13/07/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "LocalContactsViewController.h"
#import "LocalContactsCell.h"
#import "UIFont+uTu.h"
#import "СhatViewController.h"

@interface LocalContactsViewController ()

@end

@implementation LocalContactsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"local contacts %@",[[AppDelegate user] localContacts]);

}

- (void) viewWillAppear:(BOOL)animated{
    [[AppDelegate appDelegate] updateProfileImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppDelegate user] localContacts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LocalContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *key = [[[AppDelegate user] localContactsKeys] objectAtIndex:indexPath.row];
    NSMutableDictionary *localContact = [[[AppDelegate user] localContacts] objectForKey:key];
    // Configure the cell...
    cell.nameLabel.font = [UIFont Museo700Regular14];
    cell.phoneNumberLabel.font = [UIFont Museo700Regular12];
    
    cell.nameLabel.text = [localContact objectForKey:@"name"];
    cell.phoneNumberLabel.text = [localContact objectForKey:@"original_number"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([localContact objectForKey:@"id"]) {
            cell.localImageView.hidden = NO;
        }else{
            cell.localImageView.hidden = YES;
        }
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [[[AppDelegate user] localContactsKeys] objectAtIndex:indexPath.row];
    NSMutableDictionary *localContact = [[[AppDelegate user] localContacts] objectForKey:key];
    if ([localContact objectForKey:@"id"]) {
        
        NSMutableArray *contcmessages = [[NSUserDefaults standardUserDefaults] objectForKey:[localContact objectForKey:@"id"]];
        if (contcmessages) {
            [[AppDelegate user] setContactMessages:contcmessages];
        }else{
            [AppDelegate user].contactMessages = [[NSMutableArray alloc] init];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate user].contactMessages  forKey:[localContact objectForKey:@"id"]];
        
        [[AppDelegate user] setContactId:[localContact objectForKey:@"id"]];
        NSLog(@"contact id%@",[[AppDelegate user] contactId]);
        
        self.chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        [self.navigationController pushViewController:self.chatViewController animated:YES];
        
    }else{
        [[[AppDelegate appDelegate] profileView] removeFromSuperview];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Hey, I'm getting rewarded for enjoying, You can too, download UTU now! (link)";
                controller.recipients = [NSArray arrayWithObjects:[localContact objectForKey:@"original_number"], nil];
                controller.messageComposeDelegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }else{
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
            }
        });
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    NSString *trimmedString;
    if (controller.recipients.count > 0) {
        NSString *tempnumber = [[[controller.recipients objectAtIndex:0] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        trimmedString = [tempnumber substringFromIndex:MAX((int)[tempnumber length]-8, 0)];
        //        [AFUser userRequests:trimmedString];
    }
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            [AFUser userRequests:trimmedString];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
