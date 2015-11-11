//
//  AddRecipeViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "IngredientTableViewCell.h"

@interface AddRecipeViewController ()

@property (strong) NSMutableArray *recipeIngredients;
@end

@implementation AddRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    // TODO: error checking (no value provided)
    [newRecipe setValue:self.nameTextField.text forKey:@"name"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"error calling save: -- %@, %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.recipeIngredients.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeIngredientCell" forIndexPath:indexPath];

    //NSManagedObject *ingredient = [self.recipeIngredients objectAtIndex:indexPath.row];
    //[cell setLabelWithAmount:[ingredient valueForKey:@"amount"] withName:[ingredient valueForKey:@"name"]];
    [cell setLabelWithAmount:@5 withName:@"veggies"];

    return cell;
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
