//
//  NSNumber+PrimativeComparison.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 16.06.16.
//  Copyright © 2016 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (PrimativeComparison)

- (NSComparisonResult) compareWithInt:(int)i;

- (BOOL) isEqualToInt:(int)i;

- (BOOL) isGreaterThanInt:(int)i;

- (BOOL) isGreaterThanOrEqualToInt:(int)i;

- (BOOL) isLessThanInt:(int)i;

- (BOOL) isLessThanOrEqualToInt:(int)i;

@end
