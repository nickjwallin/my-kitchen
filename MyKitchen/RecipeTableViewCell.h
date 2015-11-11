//
//  RecipeTableViewCell.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeRecipeProtocol <NSObject>

- (void)makeButtonTappedForCellAtIndex:(NSInteger)index;

@end

@interface RecipeTableViewCell : UITableViewCell

- (IBAction)makeButtonTapped:(id)sender;
- (void)setLabelWithName:(NSString *)name withNumIngredients:(NSNumber *)numIngredients;

@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;
@property (assign, nonatomic) NSInteger rowIndex;

@property (weak, nonatomic) id <MakeRecipeProtocol> delegate;



@end
