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

@interface MTECategoryViewController ()

@property (nonatomic, strong) MTECategories *categories;

@end

@implementation MTECategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categories = [MTECategories sharedCategories];
    
    [self setupPieChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.pieChartView.usePercentValuesEnabled = YES;
    self.pieChartView.holeTransparent = YES;
    self.pieChartView.centerTextFont = [UIFont fontWithName:@"OpenSans-Light" size:12.f];
    self.pieChartView.holeRadiusPercent = 0.58;
    self.pieChartView.transparentCircleRadiusPercent = 0.61;
    self.pieChartView.descriptionText = @"";
    self.pieChartView.drawCenterTextEnabled = YES;
    self.pieChartView.drawHoleEnabled = YES;
    self.pieChartView.rotationAngle = 0.0;
    self.pieChartView.rotationEnabled = YES;
    
    
    ChartLegend *l = self.pieChartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    [self.pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
    
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    NSArray *expenses = [[NSArray alloc]initWithArray:[self.travel.expenses allObjects]];

    float totalAmount = 0;
    
    NSMutableDictionary *catDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < [expenses count]; i++){
        MTEExpense *expense = expenses[i];
        totalAmount += [expense.amount floatValue];
        
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
    self.pieChartView.centerText = [NSString stringWithFormat:@"%.2f", totalAmount];
    
//    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:345 xIndex:0]];
//    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:234 xIndex:1]];
//    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:1234 xIndex:2]];
//    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:23 xIndex:3]];
//    
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    
////    for (int i = 0; i < count; i++)
////    {
////        [xVals addObject:parties[i % parties.count]];
////    }
//    
//    [xVals addObject:@"Transport"];
//    [xVals addObject:@"Hebergement"];
//    [xVals addObject:@"Café"];
//    [xVals addObject:@"Souvenirs"];
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Election Results"];
    dataSet.sliceSpace = 3.0;
    
    // add a lot of colors
    
//    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
//    [colors addObjectsFromArray:ChartColorTemplates.joyful];
//    [colors addObjectsFromArray:ChartColorTemplates.colorful];
//    [colors addObjectsFromArray:ChartColorTemplates.liberty];
////    [colors addObjectsFromArray:ChartColorTemplates.pastel];
////    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    self.pieChartView.data = data;
    [self.pieChartView highlightValues:nil];
}



@end
