//
//  uTuContactsViewController.m
//  uTu
//
//  Created by Sankar on 22/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import "uTuContactsViewController.h"
#import "UIFont+uTu.h"
#import "uTuContactsCell.h"
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface uTuContactsViewController ()
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSArray *akeys;
@end

@implementation uTuContactsViewController{
    UIView *tempView;
    BOOL isSearch;
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactsView) name:@"reloadContactsView" object:Nil];
    self.searchResults = [[NSMutableDictionary alloc] init];
    self.akeys = [[NSArray alloc] init];
    self.searchResults = [[AppDelegate user] utuContacts];
    if (self.searchResults.count > 0) {
        self.akeys = [[self searchResults] allKeys];
    }
}

-(void)dismissKeyboard {
	[self.searchBar resignFirstResponder];
    [tempView removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    tempView = [[UIView alloc] init];
    tempView.frame = self.view.frame;
    [self.view addSubview:tempView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tempView addGestureRecognizer:tap];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text.length > 0) {
        self.searchResults = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [[[AppDelegate user] utuContacts] count]; i++) {
            NSString *key = [[[[AppDelegate user] utuContacts] allKeys] objectAtIndex:i];
            
            NSMutableDictionary *contact = [[[AppDelegate user] utuContacts] objectForKey:key];
            
            NSString *contactName = [contact objectForKey:@"name"];
            if ([[contactName lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound) {
                [self.searchResults setObject:contact forKey:key];
            }
        }
        if (self.searchResults.count > 0) {
            self.akeys = [[self searchResults] allKeys];
        }
    }else{
        self.searchResults = [[AppDelegate user] utuContacts];
        if (self.searchResults.count > 0) {
            self.akeys = [[self searchResults] allKeys];
        }
    }
    
    [self.tableView reloadData];
}


- (void) reloadContactsView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchBar.text = @"";
        self.searchResults = [[NSMutableDictionary alloc] init];
        self.akeys = [[NSArray alloc] init];
        self.searchResults = [[AppDelegate user] utuContacts];
        if (self.searchResults.count > 0) {
            self.akeys = [[self searchResults] allKeys];
        }
        [self.tableView reloadData];
    });
}

- (void) viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchBar.text = @"";
        self.searchResults = [[NSMutableDictionary alloc] init];
        self.akeys = [[NSArray alloc] init];
        self.searchResults = [[AppDelegate user] utuContacts];
        if (self.searchResults.count > 0) {
            self.akeys = [[self searchResults] allKeys];
        }
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [[[AppDelegate user] utuContacts] count];
    return self.searchResults.count;
    
    //    if (tableView == self.searchDisplayController.searchResultsTableView) {
    //        return [searchResults count];
    //
    //    } else {
    //        return [[[AppDelegate user] utuContacts] count];
    //    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    uTuContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *key = [self.akeys objectAtIndex:indexPath.row];
    
    NSDictionary *contact = [self.searchResults objectForKey:key];
    
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
    
    NSMutableDictionary *contact = [self.searchResults objectForKey:key];
    
    if ([[[AppDelegate user] temputuContacts] count] == 0) {
        [AppDelegate user].temputuContacts = [[NSMutableDictionary alloc] init];
    }
    if (![[[AppDelegate user] temputuContacts] objectForKey:key]) {
        [[[AppDelegate user] temputuContacts] setObject:contact forKey:key];
        [[AppDelegate user] saveStateInUserDefaults];
    }
    
    NSMutableArray *contcmessages = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (contcmessages) {
        [[AppDelegate user] setContactMessages:contcmessages];
    }else{
        [AppDelegate user].contactMessages = [[NSMutableArray alloc] init];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate user].contactMessages  forKey:key];
    
    [[AppDelegate user] setContactId:key];
    NSLog(@"contact id%@",[[AppDelegate user] contactId]);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    // allcate the chatviewcontroller
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //    NSPredicate *resultPredicate = [NSPredicate
    //                                    predicateWithFormat:@"SELF contains[cd] %@",
    //                                    searchText];
    //
    //    searchResults = [self.countries filteredArrayUsingPredicate:resultPredicate];
}

//#pragma mark - UISearchDisplayController delegate methods
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
//shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//
//    return YES;
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
