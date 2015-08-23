//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemsProvider;


@protocol Printable <NSObject>

- (NSString *)title;

- (NSString *)subtitle;

@end

@protocol ItemsProviderDelegate <NSObject>

- (void)itemsProviderDidUpdateItems:(id <ItemsProvider>)itemsProvider;

- (void)itemsProvider:(id <ItemsProvider>)itemsProvider didFailToUpdateItemsWithError:(NSError *)error;

@end

@protocol ItemsProvider <NSObject>

@property(nonatomic, weak) id <ItemsProviderDelegate> delegate;

- (NSArray /* <id <Printable>> */ *)items;

- (void)updateItems;

- (void)loadItems:(NSError **)error;

@end
