//
//  AppDelegate.m
//  Codepot
//
//  Created by Maciej Oczko on 23.08.2015.
//  Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "CoreDataStack.h"

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] init];
    }

    return self;
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    ModelController *modelController = [[ModelController alloc] initWithCoreDataStack:self.coreDataStack];
    RootViewController *rootViewController = [[RootViewController alloc] initWithModelController:modelController];

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
