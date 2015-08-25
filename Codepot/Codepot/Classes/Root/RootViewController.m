//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "TableViewController.h"
#import "EmployeesItemsProvider.h"

@interface RootViewController ()

@property(nonatomic, strong) UIViewController *containedViewController;

@end

@implementation RootViewController

- (instancetype)initWithModelController:(ModelController *)modelController {
    self = [super init];
    if (self) {
        _modelController = modelController;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Codepot Core Data";
    self.view.backgroundColor = [UIColor whiteColor];

    EmployeesItemsProvider *itemsProvider = [[EmployeesItemsProvider alloc] initWithModelController:self.modelController];
    TableViewController *tableViewController = [[TableViewController alloc] initWithItemsProvider:itemsProvider];

    //TODO: Optional
    //TODO: Make RootViewController the delegate of table view controller
    //TODO: In the did tap cell delegate callback create a new items provider for displaying people in given department
    //TODO: You will have to create a new items provider

    self.containedViewController = tableViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.containedViewController.view.frame = self.view.bounds;
}

#pragma mark - Overridden Setters

- (void)setContainedViewController:(UIViewController *)containedViewController {
    if (_containedViewController != containedViewController) {
        [_containedViewController willMoveToParentViewController:nil];
        [_containedViewController.view removeFromSuperview];
        [_containedViewController removeFromParentViewController];

        _containedViewController = containedViewController;

        [self addChildViewController:_containedViewController];
        [self.view addSubview:_containedViewController.view];
        [_containedViewController didMoveToParentViewController:self];

        [self.view setNeedsLayout];
    }
}

@end
