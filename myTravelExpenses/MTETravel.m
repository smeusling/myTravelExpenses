//
//  MTETravel.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravel.h"
#import "MTEExchangeRate.h"
#import "MTEExpense.h"
#import "AFNetworking.h"
#import "MTEConfigUtil.h"


@implementation MTETravel

@dynamic currencyCode;
@dynamic endDate;
@dynamic image;
@dynamic name;
@dynamic startDate;
@dynamic uuid;
@dynamic profileCurrencyRate;
@dynamic expenses;
@dynamic rates;

- (NSDecimalNumber *)totalAmount
{
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (MTEExpense *expense in self.expenses) {
        NSDecimalNumber *value = expense.amount;
        if ([expense.currencyCode isEqualToString:self.currencyCode] == NO) {
            for (MTEExchangeRate *rate in self.rates) {
                if ([rate.travelCurrencyCode isEqualToString:self.currencyCode]
                    && [rate.currencyCode isEqualToString:expense.currencyCode]
                    && (rate.rate != nil)) {
                    value = [expense.amount decimalNumberByMultiplyingBy:rate.rate];
                    break;
                }
            }
        }
        total = [total decimalNumberByAdding:value];
    }
    return total;
}

- (NSDecimalNumber *)totalAmountInProfileCurrency
{
    NSDecimalNumber *total = [self totalAmount];
    if ([self.currencyCode isEqualToString:[MTEConfigUtil profileCurrencyCode]] == NO && self.profileCurrencyRate) {
        total = [total decimalNumberByMultiplyingBy:self.profileCurrencyRate];
    }
    return total;
}

@end
