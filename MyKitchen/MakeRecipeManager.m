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

- (NSArray *)recipesReadyToMake {
    NSMutableArray *readyRecipes = [[NSMutableArray alloc] init];

    // get all ingredients from "pantry"
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Ingredient"];
    NSArray *pantryIngredients = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    NSMutableDictionary *pantryDict = [[NSMutableDictionary alloc] init];
    for (NSManagedObject *pantryIngredient in pantryIngredients) {
        [pantryDict setValue:[pantryIngredient valueForKey:@"amount"] forKey:[pantryIngredient valueForKey:@"name"]];
    }
    NSArray *pantryIngredientNames = [pantryDict allKeys];

    // get all recipes
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
    NSArray *recipes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    for (NSManagedObject *recipe in recipes) {
        // get recipe ingredients
        NSMutableSet *recipeIngredients = [recipe mutableSetValueForKey:@"ingredients"];
        NSMutableDictionary *recipeDict = [[NSMutableDictionary alloc] init];
        for (NSManagedObject *recipeIngredient in recipeIngredients) {
            [recipeDict setValue:[recipeIngredient valueForKey:@"amount"] forKey:[recipeIngredient valueForKey:@"name"]];
        }

        // check if recipe ingredients are available in pantry
        BOOL allIngredientsAvailable = YES;
        NSArray *recipeIngredientNames = [recipeDict allKeys];
        for (NSString *recipeIngredientName in recipeIngredientNames) {
            BOOL sufficientAmountOfIngredient = YES;

            // check if recipe ingredient available in pantry
            if ([pantryIngredientNames containsObject:recipeIngredientName]) {
                // check if there is enough of the ingredient in the pantry
                if ([pantryDict valueForKey:recipeIngredientName] < [recipeDict valueForKey:recipeIngredientName]) {
                    sufficientAmountOfIngredient = NO;
                }
            } else {
                sufficientAmountOfIngredient = NO;
            }

            // if there isn't enough of one ingredient, we don't care about this recipe
            if (!sufficientAmountOfIngredient) {
                allIngredientsAvailable = NO;
                break;
            }
        }

        // this recipe has sufficient amounts of every recipe ingredient in the pantry
        if (allIngredientsAvailable) {
            [readyRecipes addObject:recipe];
        }
    }

    return readyRecipes;
}

@end
