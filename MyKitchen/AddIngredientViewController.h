//
//  AddIngredientViewController.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/10/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddIngredientViewController : UIViewController

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)addButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
