//
//  MakeRecipeManager.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MakeRecipeManager : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 *  Subtract ingredients from the Pantry for the given recipe.
 *  If not enough ingredients are available in the Pantry, or if
 *  the amount of any ingredients hits zero, it will simply be
 *  removed from Core Data. Otherwise the ingredient amount is updated.
 *
 *  @param recipeName NSString name of the recipe to "make"
 */
- (void)makeRecipeWithName:(NSString *)recipeName;

/**
 *  Get from Core Data an NSArray of NSManagedObjects corresponding
 *  to recipes that are "ready to make" (i.e. there are enough
 *  ingredients loaded into the Pantry).
 *
 *  @return NSArray of NSManagedObjects corresponding to Recipes
 */
- (NSArray *)recipesReadyToMake;

@end
