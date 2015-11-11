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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    [self.delegate addRecipeIngredientWithAmount:[NSNumber numberWithInt:self.amountTextField.text.intValue]
                                        withName:self.nameTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
