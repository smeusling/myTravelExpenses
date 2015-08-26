//
//  MTECategoryViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 29.07.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECategoryViewController.h"
#import "MTETravel.h"
#import "MTEExpense.h"
#import "MTECategory.h"
#import "MTECategories.h"
#import "MTECurrencies.h"
#import "MTEExchangeRate.h"

@interface MTECategoryViewController ()

@property (nonatomic, strong) MTECategories *categories;

@property (nonatomic, strong) NSArray *expenses;
@property (nonatomic, strong) NSMutableDictionary *categoryDict;

@end

@implementation MTECategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categories = [MTECategories sharedCategories];
    self.categoryDict = [[NSMutableDictionary alloc]init];
    
    self.expenses = [[NSMutableArray alloc]initWithArray:[self.travel.expenses allObjects]];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setupPieChart];
    
    [self setupCategoryDictionary];
    
    [self setupHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTravelData:) name:@"MTEExpenseAdded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTravelData:) name:@"MTEExpenseRemoved" object:nil];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MTEExpenseAdded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MTEExpenseRemoved" object:nil];
}


- (void)reloadTravelData:(NSNotification *)notification
{
    self.travel = notification.userInfo[@"travel"];
    
    self.categoryDict = [[NSMutableDictionary alloc]init];
    
    self.expenses = [[NSMutableArray alloc]initWithArray:[self.travel.expenses allObjects]];
    
    [self setupPieChart];
    
    [self setupCategoryDictionary];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source / delegate

- (void)setupCategoryDictionary
{
    for (MTEExpense *expense in self.expenses) {
        if([self.categoryDict objectForKey:expense.categoryId]){
            NSDecimalNumber *total = [self.categoryDict objectForKey:expense.categoryId];
            NSDecimalNumber *value = expense.amount;
            
            if ([expense.currencyCode isEqualToString:self.travel.currencyCode] == NO) {
                for (MTEExchangeRate *rate in self.travel.rates) {
                    if ([rate.travelCurrencyCode isEqualToString:self.travel.currencyCode]
                        && [rate.currencyCode isEqualToString:expense.currencyCode]
                        && (rate.rate != nil)) {
                        value = [expense.amount decimalNumberByMultiplyingBy:rate.rate];
                        break;
                    }
                }
            }
            total = [total decimalNumberByAdding:value];
            
            [self.categoryDict setObject:total forKey:expense.categoryId];
            
            
        }else{
            NSDecimalNumber *value = expense.amount;
            
            if ([expense.currencyCode isEqualToString:self.travel.currencyCode] == NO) {
                for (MTEExchangeRate *rate in self.travel.rates) {
                    if ([rate.travelCurrencyCode isEqualToString:self.travel.currencyCode]
                        && [rate.currencyCode isEqualToString:expense.currencyCode]
                        && (rate.rate != nil)) {
                        value = [expense.amount decimalNumberByMultiplyingBy:rate.rate];
                        break;
                    }
                }
            }

            [self.categoryDict setObject:value forKey:expense.categoryId];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryDict count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    NSArray *keys = [self.categoryDict allKeys];
    
    NSString *catId = [keys objectAtIndex:indexPath.row];
    
    MTECategory *category = [[MTECategories sharedCategories]categoryById:catId];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
    nameLabel.text = category.name;
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:3];
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:self.travel.currencyCode];
    priceLabel.text = [formatter stringFromNumber:[self.categoryDict objectForKey:catId]];
    
    UIView *categoryView = (UIView *)[cell viewWithTag:1];
    categoryView.layer.cornerRadius = 10;
    categoryView.layer.masksToBounds = YES;
    
    categoryView.backgroundColor = category.color;
    
    
    return cell;
}

- (void)setupHeaderView
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, header.frame.size.width -20, header.frame.size.height - 20)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    titleLabel.text = NSLocalizedString(@"Total", nil).uppercaseString;
    
    [header addSubview:titleLabel];
    
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, header.frame.size.height - 1, header.frame.size.width, 1)];
    
    separator.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    
    [header addSubview:separator];
    
    UIView *separatorTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, header.frame.size.width, 1)];
    
    separatorTop.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    
    [header addSubview:separatorTop];
    
    
    self.tableView.tableHeaderView = header;
    
}



#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)setupPieChart
{
    
    self.pieChartView.delegate = self;
    
    [self.pieChartView setUserInteractionEnabled:NO];
    
    self.pieChartView.usePercentValuesEnabled = YES;
    self.pieChartView.holeTransparent = YES;
    self.pieChartView.centerTextFont = [UIFont fontWithName:@"OpenSans" size:12.f];
    self.pieChartView.holeRadiusPercent = 0.58;
    self.pieChartView.transparentCircleRadiusPercent = 0.61;
    self.pieChartView.descriptionText = @"";
    self.pieChartView.drawCenterTextEnabled = YES;
    self.pieChartView.drawHoleEnabled = YES;
    self.pieChartView.rotationAngle = 0.0;
    self.pieChartView.rotationEnabled = YES;
    
    
    ChartLegend *l = self.pieChartView.legend;
    [l setEnabled:NO];
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    [self.pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
    
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    NSArray *expenses = [[NSArray alloc]initWithArray:[self.travel.expenses allObjects]];
    
    NSMutableDictionary *catDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < [expenses count]; i++){
        MTEExpense *expense = expenses[i];
        
        NSNumber *amount = [catDict objectForKey:expense.categoryId];
        if(amount) {
            float amountFloat = [amount floatValue];
            amountFloat += [expense.amount floatValue];
            [catDict setObject:[NSNumber numberWithFloat: amountFloat] forKey:expense.categoryId];
        }else{
            [catDict setObject:expense.amount forKey:expense.categoryId];
        }
    }
    
    NSArray *keyArray =  [catDict allKeys];
    
    for (int i=0; i < [keyArray count]; i++) {
        MTECategory *cat = [self.categories categoryById:[ keyArray objectAtIndex:i]];
        NSNumber *amount = [catDict objectForKey:[ keyArray objectAtIndex:i]];
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:[amount floatValue] xIndex:0]];
        [xVals addObject:cat.name];
        [colors addObject:cat.color];
    }
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:self.travel.currencyCode];
    
    
    self.pieChartView.centerText = [NSString stringWithFormat:NSLocalizedString(@"TotalExpense", nil),[formatter stringFromNumber:[self.travel totalAmount]]];
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:NSLocalizedString(@"Categories", nil)];
    dataSet.sliceSpace = 3.0;
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"OpenSans" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    self.pieChartView.data = data;
    [self.pieChartView highlightValues:nil];
}



@end
