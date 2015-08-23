//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ModelController;

@interface RootViewController : UIViewController

@property(nonatomic, readonly) ModelController *modelController;

- (instancetype)initWithModelController:(ModelController *)modelController;

@end
