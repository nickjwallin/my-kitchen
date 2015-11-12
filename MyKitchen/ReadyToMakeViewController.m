//
//  ReadyToMakeViewController.m
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/11/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import "ReadyToMakeViewController.h"
#import "RecipeTableViewCell.h"
#import "AppDelegate.h"

@interface ReadyToMakeViewController () <MakeRecipeProtocol>

@property (strong) NSArray *recipes;

@end

@implementation ReadyToMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // grab the ready-to-make recipes from Core Data
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(recipesReadyToMake)]) {
        self.recipes = [delegate recipesReadyToMake];
    }

    // only show the table view if there are ready-to-make recipes
    if (self.recipes.count > 0) {
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    } else {
        [self.tableView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    cell.rowIndex = indexPath.row;
    cell.delegate = self;
    
    NSManagedObject *recipe = [self.recipes objectAtIndex:indexPath.row];
    NSMutableSet *recipeIngredients = [recipe mutableSetValueForKey:@"ingredients"];
    [cell setLabelWithName:[recipe valueForKey:@"name"] withNumIngredients:[NSNumber numberWithInteger:recipeIngredients.count]];
    
    return cell;
}

#pragma mark - MakeRecipeProtocol

- (void)makeButtonTappedForCellAtIndex:(NSInteger)index {
    NSManagedObject *recipe = [self.recipes objectAtIndex:index];
    NSString *recipeName = [recipe valueForKey:@"name"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Make %@?", recipeName]
                                                                   message:@"This will subtract ingredients from the pantry."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         id delegate = [[UIApplication sharedApplication] delegate];
                                                         if ([delegate respondsToSelector:@selector(makeRecipeWithName:)]) {
                                                             [delegate makeRecipeWithName:recipeName];
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
