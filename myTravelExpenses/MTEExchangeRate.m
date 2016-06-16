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

+ (void)getExchangeRatesForCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withCompletionHandler:(void (^)(float rate))rateBlock
{
    NSString *apiUrl = [NSString stringWithFormat:@"http://api.fixer.io/latest?base=%@&symbols=%@", fromCurrency, toCurrency];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict =[responseObject valueForKey:@"rates"];
        if ([dict valueForKey:toCurrency]){
            rateBlock([[dict valueForKey:toCurrency]floatValue]);
        }else{
            rateBlock(0);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        rateBlock(0);
    }];
}

@end
