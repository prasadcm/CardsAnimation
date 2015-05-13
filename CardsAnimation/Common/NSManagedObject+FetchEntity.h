//
//  NSManagedObject+FetchEntity.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (FetchEntity)

//Helper method for getting an existing entity from a context
+ (id)entity:(NSString*)entityName
    entityValue:(NSString*)value
      entityKey:(NSString*)key
existsInContext:(NSManagedObjectContext*)context;

// Perform case sensitive/insensitvie check
+ (id)entity:(NSString*)entityName
 entityValue:(NSString*)value
   entityKey:(NSString*)key
  ignoreCase:(BOOL)ignoreCase
existsInContext:(NSManagedObjectContext*)context;

// helper method for getting an array of existing entities from a context.
+ (NSArray *)entities:(NSString *)entityName
              ForKeys:(NSArray *)keys
            entityKey:(NSString *)keyName
        objectContext:(NSManagedObjectContext *)context;

// helper method for getting an array of existing entities from a context.
+ (NSArray *)entities:(NSString *)entityName
        withPredicate:(NSPredicate *)predicate
             sortedBy:(NSArray *)sortDescriptors
              limited:(NSInteger)count
            inContext:(NSManagedObjectContext*)context;

+(NSArray *) absentEntities:(NSString *)entityName
                    ForKeys:(NSArray *)keys
                  entityKey:(NSString *)keyName
              objectContext:(NSManagedObjectContext *)context;

+(id) entity:(NSString*)entityName
entityValueNumber:(NSNumber*)value
        entityKey:(NSString*)key
  existsInContext:(NSManagedObjectContext*)context;

+ (BOOL)entitiesExists:(NSString *)entityName
             inContext:(NSManagedObjectContext*)context;

+(id) entity:(NSString*)entityName
existsInContext:(NSManagedObjectContext*)context;

@end
