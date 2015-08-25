//
//  MTECurrencyTextField.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 25.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECurrencyTextField.h"

@implementation MTECurrencyTextField

- (void)setAmount:(NSNumber *)amount
{
    NSString *amountString = [self.currencyNumberFormatter stringFromNumber:amount];
    [self setText:amountString];
}

@end
