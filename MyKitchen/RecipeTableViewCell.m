//
//  RecipeTableViewCell.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell

- (void)setLabelWithName:(NSString *)name {
    [self.recipeLabel setText:name];
}

@end
