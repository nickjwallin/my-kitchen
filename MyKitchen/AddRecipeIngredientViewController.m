//
//  AddRecipeIngredientViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "AddRecipeIngredientViewController.h"

@interface AddRecipeIngredientViewController ()

@end

@implementation AddRecipeIngredientViewController

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    [self.delegate addRecipeIngredientWithAmount:[NSNumber numberWithInt:self.amountTextField.text.intValue]
                                        withName:self.nameTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
