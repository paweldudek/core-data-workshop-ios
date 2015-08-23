//
// Created by Maciej Oczko on 23.08.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

- (instancetype)initWithItemsProvider:(id <ItemsProvider>)itemsProvider {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _itemsProvider = itemsProvider;
        self.itemsProvider.delegate = self;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.itemsProvider loadItems:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"PrintableTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"PrintableTableViewCell"];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(didRequestRefreshing:)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Refreshing Data

- (void)didRequestRefreshing:(UIRefreshControl *)refreshControl {
    [self.itemsProvider updateItems];
}

#pragma mark - Items Provider Delegate

- (void)itemsProviderDidUpdateItems:(id <ItemsProvider>)itemsProvider {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)itemsProvider:(id <ItemsProvider>)itemsProvider didFailToUpdateItemsWithError:(NSError *)error {
    [self.refreshControl endRefreshing];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                             message:@"There's been an error when refreshing data."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsProvider.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrintableTableViewCell"
                                                            forIndexPath:indexPath];
    id <Printable> printable = self.itemsProvider.items[(NSUInteger) indexPath.row];

    cell.textLabel.text = printable.title;
    cell.detailTextLabel.text = printable.subtitle;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
