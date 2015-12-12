//
//  TestCurrencyCodes.m
//  YMoney
//
//  Created by Nikolay Morev on 12/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestCurrencyCodes : XCTestCase

@end

@implementation TestCurrencyCodes

- (void)testCurrencyCodes {
//    NSLocale *locale = [NSLocale currentLocale];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"ru"];

    NSArray *nonStandardCurrencyCodes =
    [[NSLocale ISOCurrencyCodes] filteredArrayUsingPredicate:
     [NSPredicate predicateWithBlock:^BOOL(NSString *  _Nonnull code, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![code isEqualToString:[locale displayNameForKey:NSLocaleCurrencySymbol value:code]];
    }]];

    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithMantissa:10000 exponent:-2 isNegative:NO];

    for (NSString *code in nonStandardCurrencyCodes) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = code;
        formatter.locale = locale;

        NSLog(@"%@ : %@ : %@ : %@", code,
              [locale displayNameForKey:NSLocaleCurrencyCode value:code],
              [locale displayNameForKey:NSLocaleCurrencySymbol value:code],
              [formatter stringFromNumber:amount]);
    }

}

@end
