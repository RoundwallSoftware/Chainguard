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

    UIColor *someKindOfPurple = [UIColor colorWithRed:113.0/255.0 green:60.0/255.0 blue:179.0/255.0 alpha:1.0];

    self.window.tintColor = someKindOfPurple;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    self.window.rootViewController = [storyboard instantiateInitialViewController];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
