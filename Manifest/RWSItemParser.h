//
//  RWSItemParser.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//
//

#import "RWSProject.h"

@interface RWSItemParser : NSObject
@property (nonatomic, strong) NSLocale *locale;

- (id<RWSItem>)itemFromText:(NSString *)text;
@end
