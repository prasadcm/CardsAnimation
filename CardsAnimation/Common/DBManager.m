//
//  DBManager.m
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "DBManager.h"

static NSString * const kDataManagerModelName = @"CardsAnimation";

@interface DBManager()

@end


@implementation DBManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - Initializer
SYNTHESIZE_SINGLETON_FOR_CLASS(DBManager);

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setUpDB];
    }
    return self;
}

#pragma mark - Core Data stack
- (void) setUpDB
{
    BOOL success;
    // Try to start up.  If this fails, retry it
    success = (self.managedObjectContext != nil);
    
    if (!success)
    {
        //        success = (self.managedObjectContext != nil);
        [self managedObjectContext];
    }
    [NSFetchedResultsController deleteCacheWithName:nil];
}

- (void)resetContext:(BOOL)clearDB
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    [_managedObjectContext performBlockAndWait:^(void)
     {
         NSArray *stores = [_persistentStoreCoordinator persistentStores];
         for (NSPersistentStore *store in stores) {
             [_persistentStoreCoordinator removePersistentStore:store error:nil];
             if (clearDB)
             {
                 NSURL *tmpURL = [store.URL URLByDeletingPathExtension];
                 NSURL *shmFileURL = [tmpURL URLByAppendingPathExtension:@"sqlite-shm"];
                 NSURL *walFileURL = [tmpURL URLByAppendingPathExtension:@"sqlite-wal"];
                 [[NSFileManager defaultManager] removeItemAtURL:store.URL error:nil];
                 [[NSFileManager defaultManager] removeItemAtURL:shmFileURL error:nil];
                 [[NSFileManager defaultManager] removeItemAtURL:walFileURL error:nil];
             }
         }
     }];
    
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    [self setUpDB];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *persistentStore = self.persistentStoreCoordinator;
    
    if (persistentStore != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (self->_persistentStoreCoordinator)
        return self->_persistentStoreCoordinator;
    
    // Get the paths to the SQLite file
    NSString *storePath = [[[self class] dbFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kDataManagerModelName]];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    // Define the Core Data version migration options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    // Attempt to load the persistent store
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error])
    {
        NSURL *tmpURL = [storeURL URLByDeletingPathExtension];
        NSURL *shmFileURL = [tmpURL URLByAppendingPathExtension:@"sqlite-shm"];
        NSURL *walFileURL = [tmpURL URLByAppendingPathExtension:@"sqlite-wal"];
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [[NSFileManager defaultManager] removeItemAtURL:shmFileURL error:nil];
        [[NSFileManager defaultManager] removeItemAtURL:walFileURL error:nil];
        _persistentStoreCoordinator = nil;
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
        return _managedObjectModel;
    
    NSString *modelPath =  [[NSBundle mainBundle] pathForResource:kDataManagerModelName ofType:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
    return _managedObjectModel;
}

+ (NSString *)dbFilePath
{
    
    NSURL *appSupportDir = nil;
    NSURL *dbDirectory = nil;
    BOOL isDir;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* possibleURLs = [fileManager URLsForDirectory:NSApplicationSupportDirectory
                                                inDomains:NSUserDomainMask];
    
    if ([possibleURLs count] >= 1)
    {
        // Use the first directory (if multiple are returned)
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    if (appSupportDir)
    {
        dbDirectory = [appSupportDir URLByAppendingPathComponent:@"db"];
    }
    
    if (!([fileManager fileExistsAtPath:[dbDirectory path] isDirectory:&isDir] && isDir))
    {
        NSError *error;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@YES,NSURLIsExcludedFromBackupKey, NSFileProtectionComplete, NSFileProtectionKey, nil];
        [fileManager createDirectoryAtURL:dbDirectory withIntermediateDirectories:YES attributes:attributes error:&error];
        
        if (error)
        {
            dbDirectory = nil;
        }
    }
    return [dbDirectory path];
}
@end

