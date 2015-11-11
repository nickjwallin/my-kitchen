//
//  IngredientTableViewCell.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "IngredientTableViewCell.h"

@implementation IngredientTableViewCell

- (void)setLabelWithAmount:(NSNumber *)amount withName:(NSString *)name {
    [self.ingredientLabel setText:[NSString stringWithFormat:@"%@ %@", amount, name]];
}

@end
