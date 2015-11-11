//
//  RecipeTableViewCell.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;

- (void)setLabelWithName:(NSString *)name;

@end
