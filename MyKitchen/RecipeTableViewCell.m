//
//  RecipeTableViewCell.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell

- (void)setLabelWithName:(NSString *)name withNumIngredients:(NSNumber *)numIngredients {
    [self.recipeLabel setText:[NSString stringWithFormat:@"%@ (%@ ingredients)", name, numIngredients]];
}

@end
