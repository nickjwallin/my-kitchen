//
//  AddRecipeViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "AddRecipeViewController.h"
#import "IngredientTableViewCell.h"
#import "AddRecipeIngredientViewController.h"

@interface AddRecipeViewController () <AddRecipeIngredientProtocol>

@property (strong) NSMutableArray *recipeIngredients;

@end

@implementation AddRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.recipeIngredients = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"AddRecipeIngredientSegue"]) {
        UINavigationController *addRecipeIngredientNavController = [segue destinationViewController];
        AddRecipeIngredientViewController *addRecipeIngredientVC = [addRecipeIngredientNavController.childViewControllers firstObject];
        addRecipeIngredientVC.delegate = self;
    }
}

#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    [self saveRecipeToCoreData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipeIngredients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeIngredientCell" forIndexPath:indexPath];
    
    NSDictionary *ingredient = [self.recipeIngredients objectAtIndex:indexPath.row];
    NSString *name = [[ingredient allKeys] firstObject];
    NSNumber *amount = [ingredient valueForKey:name];
    [cell setLabelWithAmount:amount withName:name];

    return cell;
}

#pragma mark - AddRecipeIngredientProtocol

-(void)addRecipeIngredientWithAmount:(NSNumber *)amount withName:(NSString *)name {
    if (amount && name) {
        NSDictionary *ingredient = [[NSDictionary alloc] initWithObjects:@[amount] forKeys:@[name]];
        [self.recipeIngredients addObject:ingredient];
    }
}

#pragma mark - Core Data

- (void)saveRecipeToCoreData {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];

    // TODO: error checking (no value provided)
    NSString *recipeName = self.nameTextField.text;
    [newRecipe setValue:recipeName forKey:@"name"];

    NSMutableSet *recipeIngredients = [newRecipe mutableSetValueForKey:@"ingredients"];

    for (NSDictionary *ingredient in self.recipeIngredients) {
        NSManagedObject *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"RecipeIngredient" inManagedObjectContext:context];

        [newIngredient setValue:recipeName forKey:@"recipeName"];
        NSString *name = [[ingredient allKeys] firstObject];
        NSNumber *amount = [ingredient valueForKey:name];
        [newIngredient setValue:name forKey:@"name"];
        [newIngredient setValue:amount forKey:@"amount"];

        [recipeIngredients addObject:newIngredient];
    }

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"error calling save: -- %@, %@", error, [error localizedDescription]);
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
