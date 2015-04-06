//
//  NSLocale+RWSCurrency.h
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//

@interface NSLocale (RWSCurrency)

- (NSLocale *)localeWithCurrency:(NSString *)currency;
@property (readonly, copy) NSString *currencySymbol;
@property (readonly, copy) NSString *currencyCode;

@end
