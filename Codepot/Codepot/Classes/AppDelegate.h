//
//  AppDelegate.h
//  Codepot
//
//  Created by Maciej Oczko on 23.08.2015.
//  Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataStack;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) CoreDataStack *coreDataStack;

@end

