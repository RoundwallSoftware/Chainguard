//
//  RWSAppDelegate.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSAppDelegate.h"
#import "RWSProjectsViewController.h"
#import "UIColor+iOS7Colors.h"

@interface RWSAppDelegate()
@end

@implementation RWSAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupTheme];
    return YES;
}

- (void)setupTheme
{
    UIColor *tintColor = [UIColor iOS7purpleColor];
    self.window.tintColor = tintColor;

    UIFont *headingFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: tintColor, NSFontAttributeName: headingFont} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: headingFont} forState:UIControlStateDisabled];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.01]];
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    NSLog(@"Saving state");
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    NSString *buildNumberString = [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey];
    NSDate *timestamp = [coder decodeObjectForKey:UIApplicationStateRestorationTimestampKey];
    NSLog(@"Should restore with bundle version: %@, %@", buildNumberString, timestamp);
    return NO;
}

@end
