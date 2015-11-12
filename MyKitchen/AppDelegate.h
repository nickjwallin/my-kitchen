//
//  AppDelegate.h
//  MyKitchen
//
//  Created by Nicholas Wallin on 11/9/15.
//  Copyright © 2015 Nicholas J. Wallin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

#pragma mark - Make Recipe Manager
- (void)makeRecipeWithName:(NSString *)recipeName;
- (NSArray *)recipesReadyToMake;

@end

