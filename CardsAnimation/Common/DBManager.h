//
//  DBManager.h
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBManager : NSObject

@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)resetContext:(BOOL)clearDB;

SYNTHESIZE_SINGLETON_METHOD_FOR_CLASS(DBManager);

@end