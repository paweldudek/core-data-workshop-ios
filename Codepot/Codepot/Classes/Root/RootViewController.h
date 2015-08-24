//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ModelController;
@class SearchEmployeesItemsProvider;

@interface RootViewController : UIViewController

@property(nonatomic, readonly) ModelController *modelController;

@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) SearchEmployeesItemsProvider *searchItemsProvider;

- (instancetype)initWithModelController:(ModelController *)modelController;

@end
