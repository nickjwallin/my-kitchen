//
//  AddIngredientViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "AddIngredientViewController.h"

@interface AddIngredientViewController ()

@end

@implementation AddIngredientViewController

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
    // TODO: error checking (no values provided)
    [newIngredient setValue:self.nameTextField.text forKey:@"name"];
    NSNumber *amount = [NSNumber numberWithInt:self.amountTextField.text.intValue];
    [newIngredient setValue:amount forKey:@"amount"];

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"error calling save: -- %@, %@", error, [error localizedDescription]);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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
