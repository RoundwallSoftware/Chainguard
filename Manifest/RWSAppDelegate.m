//
//  RWSAppDelegate.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//
//

#import "RWSAppDelegate.h"
#import "UIColor+RWSAppColors.h"
#import "RWSExchangeRates.h"
#import "Crittercism.h"

@interface RWSAppDelegate()
@property (nonatomic, strong) RWSExchangeRates *rates;
@end

@implementation RWSAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setMinimumBackgroundFetchInterval:60.0*60.0];

    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ RWSFormattedLastTimeExchangeRateUpdated: @"Not Yet" }];

    [self setupTheme];

#ifndef DEBUG
     [Crittercism enableWithAppID:@"533fb401a6d3d7064a000002"];
#endif

    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    self.rates = [[RWSExchangeRates alloc] init];
    [self.rates updateRatesWithCompletionHandler:completionHandler];
}

- (void)setupTheme
{
    UIColor *tintColor = [UIColor tintColor];
    self.window.tintColor = tintColor;

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: tintColor } forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
