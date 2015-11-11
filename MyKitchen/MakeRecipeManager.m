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
    NSLog(@"made the recipe!");
}

@end
