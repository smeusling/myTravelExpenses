//
//  MTECurrencyTableViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECurrencyTableViewController.h"
#import "MTECurrencies.h"
#import "MTEExchangeRate.h"

@interface MTECurrencyTableViewController()

@property (nonatomic, strong) NSMutableOrderedSet *sections;
@property (nonatomic, strong) NSMutableDictionary *codesBySections;

@property (nonatomic, strong) NSMutableOrderedSet *searchSections;
@property (nonatomic, strong) NSMutableDictionary *searchCodesBySections;

@property (nonatomic, strong) NSString *filterString;

@end

@implementation MTECurrencyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = (NSMutableOrderedSet *)[[MTECurrencies sharedInstance] sections];
    self.codesBySections = (NSMutableDictionary *)[[MTECurrencies sharedInstance] currencyCodesBySections];
    
    
    
    if ([self.travelRates count] > 0){
        [self.sections insertObject:@"0" atIndex:0];
        NSMutableArray *currencies = [[NSMutableArray alloc]init];
        for (MTEExchangeRate *rate in self.travelRates) {
            [currencies addObject:rate.currencyCode];
        }
        self.codesBySections[@"0"] = currencies;
    }
    
    self.searchSections = self.sections;
    self.searchCodesBySections = self.codesBySections;
    
    [self setupNavBar];
}

#pragma mark - Setup

- (void)setupNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
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
    NSString *title;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        title = [self.searchSections objectAtIndex:section];
    } else {
        title = [self.sections objectAtIndex:section];
    }
    
    if ([title isEqualToString:@"0"]){
        title = @"Monnaies déjà utilisées";
    }
    return title;
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

- (void)closeButtonTapped
{
    [self.delegate cancelCurrencyPicker];
}


@end

