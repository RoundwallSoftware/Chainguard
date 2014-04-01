//
//  RWSAppDelegate.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSAppDelegate.h"
#import "UIColor+iOS7Colors.h"
#import "RWSExchangeRates.h"

@interface RWSAppDelegate()
@property (nonatomic, strong) RWSExchangeRates *rates;
@end

@implementation RWSAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setMinimumBackgroundFetchInterval:60.0*60.0];

    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ RWSFormattedLastTimeExchangeRateUpdated: @"Not Yet" }];

    [self setupTheme];

    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    self.rates = [[RWSExchangeRates alloc] init];
    [self.rates updateRatesWithCompletionHandler:completionHandler];
}

- (void)setupTheme
{
    UIColor *tintColor = [UIColor iOS7purpleColor];
    self.window.tintColor = tintColor;

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: tintColor } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor iOS7lightGrayColor]} forState:UIControlStateDisabled];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.01]];
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
