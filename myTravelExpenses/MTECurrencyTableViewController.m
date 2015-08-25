//
//  MTECurrencyTableViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECurrencyTableViewController.h"
#import "MTECurrencies.h"

@interface MTECurrencyTableViewController()

@property (nonatomic, strong) NSOrderedSet *sections;
@property (nonatomic, strong) NSDictionary *codesBySections;

@property (nonatomic, strong) NSOrderedSet *searchSections;
@property (nonatomic, strong) NSDictionary *searchCodesBySections;

@property (nonatomic, strong) NSString *filterString;

@end

@implementation MTECurrencyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = [[MTECurrencies sharedInstance] sections];
    self.codesBySections = [[MTECurrencies sharedInstance] currencyCodesBySections];
    
    self.searchSections = [[MTECurrencies sharedInstance] sections];
    self.searchCodesBySections = [[MTECurrencies sharedInstance] currencyCodesBySections];
}

- (void)reloadSearchDataAndSections
{
    NSMutableOrderedSet *mutableSearchSections = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary *mutableSearchCodesBySections = [NSMutableDictionary dictionary];
    
    for (NSString *section in self.sections) {
        NSMutableArray *currencies = [self.codesBySections valueForKey:section];
        for (NSString *code in currencies) {
            NSString *name = [[MTECurrencies sharedInstance] currencyFullNameForCode:code];
            if ([name rangeOfString:self.filterString options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch].location != NSNotFound) {
                NSMutableArray *currentCodes = [mutableSearchCodesBySections valueForKey:section];
                if (currentCodes == nil) {
                    currentCodes = [NSMutableArray array];
                    [mutableSearchCodesBySections setValue:currentCodes forKey:section];
                    [mutableSearchSections addObject:section];
                }
                [currentCodes addObject:code];
            }
        }
    }
    
    self.searchSections = [NSOrderedSet orderedSetWithOrderedSet:mutableSearchSections];
    self.searchCodesBySections = [NSDictionary dictionaryWithDictionary:mutableSearchCodesBySections];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - Search Display Controller

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSInteger searchOption = controller.searchBar.selectedScopeButtonIndex;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString *searchString = controller.searchBar.text;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString*)searchString searchScope:(NSInteger)searchOption {
    
    self.filterString = searchString;
    
    [self reloadSearchDataAndSections];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchCodesBySections count];
    } else {
        return [self.codesBySections count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchSections objectAtIndex:section];
    } else {
        return [self.sections objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *sectionKey = [self.searchSections objectAtIndex:section];
        return [(NSArray *)[self.searchCodesBySections valueForKey:sectionKey] count];
    } else {
        NSString *sectionKey = [self.sections objectAtIndex:section];
        return [(NSArray *)[self.codesBySections valueForKey:sectionKey] count];
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchSections array];
    } else {
        return [self.sections array];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CurrencyCell"];
    }
    UILabel *currencyLabel = cell.textLabel;
    currencyLabel.adjustsFontSizeToFitWidth = YES;
    currencyLabel.minimumScaleFactor = 0.5;
    
    NSString *section;
    NSString *code;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        section = [self.searchSections objectAtIndex:indexPath.section];
        code = [[self.searchCodesBySections valueForKey:section] objectAtIndex:indexPath.row];
    } else {
        section = [self.sections objectAtIndex:indexPath.section];
        code = [[self.codesBySections valueForKey:section] objectAtIndex:indexPath.row];
    }
    currencyLabel.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:code];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section;
    NSString *code;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        section = [self.searchSections objectAtIndex:indexPath.section];
        code = [[self.searchCodesBySections valueForKey:section] objectAtIndex:indexPath.row];
    } else {
        section = [self.sections objectAtIndex:indexPath.section];
        code = [[self.codesBySections valueForKey:section] objectAtIndex:indexPath.row];
    }
    [self.delegate selectedCurrencyWithCode:code];
}

@end

