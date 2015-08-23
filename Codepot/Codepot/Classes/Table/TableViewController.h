//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ItemsProvider.h"

@protocol ItemsProvider;

@protocol TableViewControllerDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TableViewController : UITableViewController <ItemsProviderDelegate>
@property(nonatomic, weak) id <TableViewControllerDelegate> delegate;
@property(nonatomic, strong, readonly) id <ItemsProvider> itemsProvider;

- (instancetype)initWithItemsProvider:(id <ItemsProvider>)itemsProvider;

@end
