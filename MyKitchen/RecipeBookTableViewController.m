//
//  RecipeBookTableViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "RecipeBookTableViewController.h"
#import "RecipeTableViewCell.h"
#import "AppDelegate.h"

@interface RecipeBookTableViewController () <MakeRecipeProtocol>

@property (strong) NSMutableArray *recipes;

@end

@implementation RecipeBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Grab the recipes from Core Data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
    self.recipes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    cell.rowIndex = indexPath.row;
    cell.delegate = self;
    
    NSManagedObject *recipe = [self.recipes objectAtIndex:indexPath.row];
    NSMutableSet *recipeIngredients = [recipe mutableSetValueForKey:@"ingredients"];
    [cell setLabelWithName:[recipe valueForKey:@"name"] withNumIngredients:[NSNumber numberWithInteger:recipeIngredients.count]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MakeRecipeProtocol

- (void)makeButtonTappedForCellAtIndex:(NSInteger)index {
    NSManagedObject *recipe = [self.recipes objectAtIndex:index];
    NSString *recipeName = [recipe valueForKey:@"name"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Make %@?", recipeName]
                                                                   message:@"This will subtract ingredients from the pantry."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         id delegate = [[UIApplication sharedApplication] delegate];
                                                         if ([delegate respondsToSelector:@selector(makeRecipeWithName:)]) {
                                                             [delegate makeRecipeWithName:recipeName];
                                                         }
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
