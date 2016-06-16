//
//  MTEExchangeRate.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEExchangeRate.h"
#import "MTETravel.h"
#import "AFNetworking.h"


@implementation MTEExchangeRate

@dynamic currencyCode;
@dynamic travelCurrencyCode;
@dynamic rate;
@dynamic travel;

+ (void)getExchangeRates:(void (^)(NSDictionary *))ratesBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json&" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSArray *array = [[responseObject valueForKey:@"list"] valueForKey:@"resources"];
        for (NSDictionary *item in array) {
            NSDictionary *fields = [[item valueForKey:@"resource"] valueForKey:@"fields"];
            NSString *name = [fields valueForKey:@"name"];
            NSString *price = [fields valueForKey:@"price"];
            if ([name hasPrefix:@"USD/"]) {
                NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:price];
                [result setValue:value forKey:[name substringFromIndex:4]];
            }
        }
        ratesBlock(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        ratesBlock([NSDictionary dictionary]);
    }];
}

+ (void)getExchangeRatesForCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withCompletionHandler:(void (^)(NSDecimalNumber* rate))rateBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json&" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSArray *array = [[responseObject valueForKey:@"list"] valueForKey:@"resources"];
        for (NSDictionary *item in array) {
            NSDictionary *fields = [[item valueForKey:@"resource"] valueForKey:@"fields"];
            NSString *name = [fields valueForKey:@"name"];
            NSString *price = [fields valueForKey:@"price"];
            if ([name hasPrefix:@"USD/"]) {
                NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:price];
                [result setValue:value forKey:[name substringFromIndex:4]];
            }
        }
        NSDecimalNumber *usdToEventCurrencyRate;
        if ([fromCurrency isEqualToString:@"USD"] == NO) {
            usdToEventCurrencyRate = [result valueForKey:fromCurrency];
        } else {
            usdToEventCurrencyRate = [NSDecimalNumber one];
        }
        NSDecimalNumber *usdToPaymentCurrencyRate;
        if ([toCurrency isEqualToString:@"USD"] == NO) {
            usdToPaymentCurrencyRate = [result valueForKey:toCurrency];
        } else {
            usdToPaymentCurrencyRate = [NSDecimalNumber one];
        }
        
        if (usdToEventCurrencyRate && usdToPaymentCurrencyRate) {
            rateBlock([usdToEventCurrencyRate decimalNumberByDividingBy:usdToPaymentCurrencyRate]);
        } else {
            rateBlock([NSDecimalNumber zero]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        rateBlock([NSDecimalNumber zero]);
    }];
}

@end
