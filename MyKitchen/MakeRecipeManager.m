//
//  MakeRecipeManager.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "MakeRecipeManager.h"

@interface MakeRecipeManager ()

@property (strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation MakeRecipeManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)makeRecipeWithName:(NSString *)recipeName {
    // get the recipe with the specified name
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", recipeName];
    [fetchRequest setPredicate:predicate];
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    NSManagedObject *recipe = nil;

    if (!fetchError) {
        recipe = [result firstObject];
        NSLog(@"got recipe with name %@", [recipe valueForKey:@"name"]);
    } else {
        NSLog(@"Error fetching recipe.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
        return;
    }

    // get the ingredients of the recipe
    NSMutableSet *recipeIngredients = [recipe mutableSetValueForKey:@"ingredients"];
    NSLog(@"got %@ ingredients for that recipe!", [NSNumber numberWithInteger:recipeIngredients.count]);
    NSMutableSet *ingredientNames = [[NSMutableSet alloc] init];
    for (NSManagedObject *recipeIngredient in recipeIngredients) {
        [ingredientNames addObject:[recipeIngredient valueForKey:@"name"]];
    }

    // get those ingredients from the "pantry"
    NSFetchRequest *ingredientFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Ingredient"];
    NSPredicate *ingredientPredicate = [NSPredicate predicateWithFormat:@"name in %@", ingredientNames];
    [ingredientFetchRequest setPredicate:ingredientPredicate];

    fetchError = nil;
    NSArray *pantryIngredients = [self.managedObjectContext executeFetchRequest:ingredientFetchRequest error:&fetchError];

    if (!fetchError) {
        // subtract ingredients from "pantry"
        for (NSManagedObject *recipeIngredient in recipeIngredients) {
            NSString *recipeIngredientName = [recipeIngredient valueForKey:@"name"];
            NSNumber *recipeAmount = [recipeIngredient valueForKey:@"amount"];
            for (NSManagedObject *pantryIngredient in pantryIngredients) {
                NSString *pantryIngredientName = [pantryIngredient valueForKey:@"name"];
                if ([pantryIngredientName isEqualToString:recipeIngredientName]) {
                    NSNumber *pantryAmount = [pantryIngredient valueForKey:@"amount"];
                    int newPantryAmount = pantryAmount.intValue > recipeAmount.intValue ? pantryAmount.intValue - recipeAmount.intValue : 0;
                    if (newPantryAmount > 0) {
                        // update pantry amount
                        [pantryIngredient setValue:[NSNumber numberWithInt:newPantryAmount] forKey:@"amount"];
                    } else {
                        // delete pantry record
                        [self.managedObjectContext deleteObject:pantryIngredient];
                    }

                    // save change to pantry ingredient
                    NSError *saveError = nil;
                    if(![pantryIngredient.managedObjectContext save:&saveError]) {
                        NSLog(@"Error saving change to pantry ingredient -- %@", [saveError localizedDescription]);
                    }
                }
            }
        }
    } else {
        NSLog(@"Error fetching pantry ingredients.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
        return;
    }
}

@end
