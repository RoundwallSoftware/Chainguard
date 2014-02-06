//
//  RWSAppDelegate.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSAppDelegate.h"
#import "RWSProjectsViewController.h"

@interface RWSAppDelegate()
@end

@implementation RWSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    self.window.rootViewController = [storyboard instantiateInitialViewController];

    [self.window makeKeyAndVisible];

    UIColor *someKindOfBlue = [UIColor colorWithRed:59.0/255.0 green:104.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.window.tintColor = someKindOfBlue;
    self.window.backgroundColor = [UIColor blackColor];
    
    UIFont *headingFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: someKindOfBlue, NSFontAttributeName: headingFont} forState:UIControlStateNormal];
    return YES;
}

@end
