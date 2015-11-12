//
//  RecipeTableViewCell.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeRecipeProtocol <NSObject>

/**
 *  Handle the tapping of the "make" button for this cell.
 *
 *  @param index The row index of this cell
 */
- (void)makeButtonTappedForCellAtIndex:(NSInteger)index;

@end

@interface RecipeTableViewCell : UITableViewCell

- (IBAction)makeButtonTapped:(id)sender;

/**
 *  Update the label text with the given information.
 *
 *  @param name           The name of the recipe
 *  @param numIngredients The number of ingredients in the recipe
 */
- (void)setLabelWithName:(NSString *)name withNumIngredients:(NSNumber *)numIngredients;

@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;
@property (assign, nonatomic) NSInteger rowIndex;

@property (weak, nonatomic) id <MakeRecipeProtocol> delegate;



@end
