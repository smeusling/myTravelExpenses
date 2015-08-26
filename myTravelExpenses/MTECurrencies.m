//
//  MTECurrencies.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECurrencies.h"

@interface MTECurrencies()

@property (nonatomic, strong) NSDictionary *currencyNamesByCode;

@end

@implementation MTECurrencies

+ (MTECurrencies *)sharedInstance
{
    static MTECurrencies *currencies;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currencies = [[MTECurrencies alloc] init];
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"FileName"
                                                             ofType:@"plist"];
        NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        // This file was built from wikipedia http://en.wikipedia.org/wiki/ISO_4217
        NSString* file = [[NSBundle mainBundle] pathForResource:@"currencies" ofType:@"csv"];
        NSString* fileContents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        
        NSArray* lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        for (NSString *line in lines) {
            NSArray *tokens = [line componentsSeparatedByString:@"\t"];
            if ([tokens count] >= 4) {
                NSString *code = [[tokens objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *name = [[tokens objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([name rangeOfString:@"("].location == NSNotFound) {
                    [result setValue:NSLocalizedStringFromTable(name, @"Currencies", nil) forKey:code];
                }
            } else {
                NSLog(@"Invalid line in currencies.csv file: %@", line);
            }
        }
        
        [result removeObjectForKey:@"CNH"];
        [result removeObjectForKey:@"XUA"];
        [result removeObjectForKey:@"XXX"];
        [result removeObjectForKey:@"XTS"];
        
        currencies.currencyNamesByCode = [NSDictionary dictionaryWithDictionary:result];
    });
    
    return currencies;
}

- (NSArray *)currencyCodes
{
    return [[self.currencyNamesByCode allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *code1 = (NSString *) a;
        NSString *code2 = (NSString *) b;
        NSString *name1 = [self currencyNameForCode:code1];
        NSString *name2 = [self currencyNameForCode:code2];
        return [name1 compare:name2];
    }];
}

- (NSOrderedSet *)sections
{
    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];
    
    NSArray *sortedCurrencies = [self currencyCodes];
    
    for (NSString *code in sortedCurrencies) {
        NSString *name = [self currencyNameForCode:code];
        NSString *section = [[name substringToIndex:1] uppercaseString];
        [result addObject:section];
    }
    
    return result;
}

- (NSDictionary *)currencyCodesBySections
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSArray *sortedCurrencies = [self currencyCodes];
    
    for (NSString *code in sortedCurrencies) {
        NSString *name = [self currencyNameForCode:code];
        NSString *section = [[name substringToIndex:1] uppercaseString];
        NSMutableArray *sectionValues = [result valueForKey:section];
        if (sectionValues == nil) {
            sectionValues = [NSMutableArray array];
            [result setValue:sectionValues forKey:section];
        }
        [sectionValues addObject:code];
    }
    
    return result;
}

- (NSString *)currencyNameForCode:(NSString *)code
{
    return [self.currencyNamesByCode valueForKey:code];
}

- (NSString *)currencyFullNameForCode:(NSString *)code
{
    NSString *name = [[MTECurrencies sharedInstance] currencyNameForCode:code];
    NSString *symbol = [[MTECurrencies sharedInstance] currencySymbolForCode:code];
    if ([code isEqualToString:symbol]) {
        return [NSString stringWithFormat:@"%@ - %@", name, symbol];
    } else {
        return [NSString stringWithFormat:@"%@ - %@ - %@", name, symbol, code];
    }
}

- (NSString *)currencySymbolForCode:(NSString *)code
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setCurrencyCode:code];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    NSString *symbol = [[numberFormatter stringFromNumber:[NSNumber numberWithInt:0]] stringByReplacingOccurrencesOfString:@"0" withString:@""];
    symbol = [symbol stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([symbol isEqualToString:code] == NO) {
        return symbol;
    } else {
        return code;
    }
}

+ (NSNumberFormatter *)formatter:(NSString *)currencyCode
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    formatter.usesGroupingSeparator = YES;
    formatter.currencySymbol = [[MTECurrencies sharedInstance] currencySymbolForCode:currencyCode];
    return formatter;
}

+ (NSNumberFormatter *)formatter10Digits:(NSString *)currencyCode
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.locale = [NSLocale currentLocale];
    formatter.maximumFractionDigits = 6;
    formatter.usesGroupingSeparator = YES;
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    formatter.currencySymbol = [[MTECurrencies sharedInstance] currencySymbolForCode:currencyCode];
    return formatter;
}

+ (NSNumberFormatter *)formatterNoCurrency10Digits:(NSString *)currencyCode
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumIntegerDigits = 1;
    formatter.locale = [NSLocale currentLocale];
    formatter.maximumFractionDigits = 6;
    formatter.usesGroupingSeparator = YES;
    return formatter;
}

@end

