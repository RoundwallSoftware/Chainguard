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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    self.window.rootViewController = [storyboard instantiateInitialViewController];

    [self.window makeKeyAndVisible];

    [self setupTheme];
    return YES;
}

- (void)setupTheme
{
    UIColor *tintColor = [UIColor iOS7purpleColor];
    self.window.tintColor = tintColor;

    UIFont *headingFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: tintColor, NSFontAttributeName: headingFont} forState:UIControlStateNormal];
}

@end
