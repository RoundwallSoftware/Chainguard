//
//  RWSReverseItemParser.h
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//
//

#import <Foundation/Foundation.h>

@interface RWSReverseItemParser : NSObject

- (void)setName:(NSString *)name;
- (void)setPriceInput:(NSString *)priceInput;

@property (readonly, copy) NSString *inputString;

@end
