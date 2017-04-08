//
//  AppDelegate.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 21.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "VKSdk.h"
#import "RKDropdownAlert.h"

#import "SWRevealViewController.h"

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;


@end

