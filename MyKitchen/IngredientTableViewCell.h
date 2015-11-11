//
//  IngredientTableViewCell.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;

- (void)setLabelWithAmount:(NSNumber *)amount withName:(NSString *)name;

@end
