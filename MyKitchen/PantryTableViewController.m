//
//  PantryTableViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "PantryTableViewController.h"
#import "IngredientTableViewCell.h"

@interface PantryTableViewController ()

@property (strong) NSMutableArray *ingredients;

@end

@implementation PantryTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Grab the ingredients from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Ingredient"];
    self.ingredients = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientCell" forIndexPath:indexPath];
    
    NSManagedObject *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    [cell setLabelWithAmount:[ingredient valueForKey:@"amount"] withName:[ingredient valueForKey:@"name"]];
    
    return cell;
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
