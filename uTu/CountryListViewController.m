//
//  CountryListViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"
#import "UIFont+uTu.h"

@interface CountryListViewController ()

@property (strong, nonatomic) NSArray *dataRows;
@property (strong, nonatomic) NSMutableArray *countries;
@end

@implementation CountryListViewController{
    NSString *selectedText;
    NSArray *searchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedText = @"India";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    self.countries = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataRows.count; i++) {
        [self.countries addObject:[[self.dataRows objectAtIndex:i] valueForKey:kCountryName]];
    }
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.dataRows count];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.countries count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
//        cell.textLabel.text = [[self.dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName];
        cell.textLabel.text = [self.countries objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont Museo700Regular14];
    }
    
    if ([selectedText isEqualToString:cell.textLabel.text]) {
        [cell setSelected:YES];
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.3, cell.frame.size.width, 0.3)];
    lineView.backgroundColor = [UIColor colorWithRed:((137) / 255.0f)
                                               green:((93) / 255.0f)
                                                blue:((121) / 255.0f)
                                               alpha:1.0f];
    [cell.contentView addSubview:lineView];
    
//    cell.detailTextLabel.text = [[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode];
    
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedValue;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedValue = [searchResults objectAtIndex:indexPath.row];
    }else{
        selectedValue = [self.countries objectAtIndex:indexPath.row];
    }
    
    for (int i = 0; i < self.dataRows.count; i++) {
        if ([selectedValue isEqualToString:[[self.dataRows objectAtIndex:i] valueForKey:kCountryName]]) {
            [self.delegate didSelectCountry:[_dataRows objectAtIndex:i]];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [self.countries filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


#pragma mark -
#pragma mark Actions

//- (IBAction)done:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(didSelectCountry:)]) {
//        [self.delegate didSelectCountry:[_dataRows objectAtIndex:[_tableView indexPathForSelectedRow].row]];
//        [self dismissViewControllerAnimated:YES completion:NULL];
//    } else {
//        NSLog(@"CountryListView Delegate : didSelectCountry not implemented");
//    }
//}

@end
