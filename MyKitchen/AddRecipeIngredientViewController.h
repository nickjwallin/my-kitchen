//
//  AddRecipeIngredientViewController.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddRecipeIngredientProtocol <NSObject>

/**
 *  Add the ingredient to the recipe. No Core Data stuff is
 *  done until the entire recipe is saved.
 *
 *  @param amount Amount of the ingredient in the recipe
 *  @param name   Name of the ingredient
 */
- (void)addRecipeIngredientWithAmount:(NSNumber *)amount withName:(NSString *)name;

@end

@interface AddRecipeIngredientViewController : UIViewController

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)addButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) id <AddRecipeIngredientProtocol> delegate;

@end


