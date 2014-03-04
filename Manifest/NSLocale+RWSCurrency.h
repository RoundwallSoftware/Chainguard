//
//  NSLocale+RWSCurrency.h
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//  Copyright (c) 2013 Roundwall Software. All rights reserved.
//

@interface NSLocale (RWSCurrency)

+ (NSLocale *)currentLocaleWithCurrency:(NSString *)currency;
- (NSString *)currencySymbol;
- (NSString *)currencyCode;

@end
