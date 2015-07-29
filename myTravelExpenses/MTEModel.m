//
//  MTEModel.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 24.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEModel.h"
#import "MTETravel.h"
#import "MTEExpense.h"

@interface MTEModel()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MTEModel

+ (MTEModel *)sharedInstance
{
    static MTEModel *model;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[MTEModel alloc] init];
    });
    
    return model;
}

#pragma mark - Core Data
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"myTravelExpenses" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"myTravelExpenses.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        //Si ça fait un abort c'est parce que la base de donnée à été changée et que le model n'est plus le même; il suffit d'effacer les fihcier qui se trouvent ici :/Users/stephaniemeusling/Library/Developer/CoreSimulator/Devices/AFC3EF74-7DCC-4057-BAC4-1EE366C45010/data/Containers/Data/Application/DAD2D514-D3F2-4C4F-88BC-5D18C9666AA1/Documents
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Other model object methods
- (MTETravel *)createTravel
{
    NSManagedObjectContext *context = [self managedObjectContext];
    MTETravel *travel = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Travel"
                         inManagedObjectContext:context];
    travel.uuid = [[NSUUID UUID] UUIDString];
    travel.name = @"Travel";
    
//    MTEExpense *expense = [NSEntityDescription
//                           insertNewObjectForEntityForName:@"Expense"
//                           inManagedObjectContext:context];
//    expense.date = [NSDate date];
//    expense.name = @"exp";
//    expense.amount = [NSNumber numberWithFloat:12345.9];
//    expense.travel = travel;
//    
//    travel.expenses = [NSSet setWithObjects:expense, nil];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    return travel;
}

-(MTETravel *)createTravelWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(NSData *)image currencyCode:(NSString *)currencyCode
{
    NSManagedObjectContext *context = [self managedObjectContext];
    MTETravel *travel = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Travel"
                         inManagedObjectContext:context];
    travel.uuid = [[NSUUID UUID] UUIDString];
    travel.name = name;
    travel.startDate = startDate;
    travel.endDate = endDate;
    travel.image = image;
    travel.currencyCode = currencyCode;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    return travel;
}

-(MTEExpense *)createExpenseWithName:(NSString *)name date:(NSDate *)date amount:(NSNumber *)amount travel:(MTETravel *)travel currencyCode:(NSString *)currencyCode category:(MTECategory *)category
{
    NSManagedObjectContext *context = [self managedObjectContext];
    MTEExpense *expense = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Expense"
                         inManagedObjectContext:context];
    expense.uuid = [[NSUUID UUID] UUIDString];
    expense.name = name;
    expense.date = date;
    expense.amount = amount;
    expense.travel = travel;
    expense.currencyCode = currencyCode;
    expense.category = category;

    travel.expenses = [NSSet setWithObject:expense];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    return expense;
}



@end