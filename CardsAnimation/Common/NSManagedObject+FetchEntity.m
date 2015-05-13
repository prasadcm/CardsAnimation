//
//  NSManagedObject+FetchEntity.m
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import "NSManagedObject+FetchEntity.h"
#import <objc/runtime.h>

@implementation NSManagedObject (FetchEntity)

+(id) entity:(NSString*)entityName
 entityValue:(NSString*)value
   entityKey:(NSString*)key
existsInContext:(NSManagedObjectContext*)context
{
    // Get a reference to the indicated entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",key, value];
    
    // Create and configure a select request against that entity.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    // Execute the request.
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (error)
    {
        SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
    }
    
    // Clean up and return the results.
    
    if(results.count > 0)
        return [results objectAtIndex:0];
    return nil;
    
}

+ (id)entity:(NSString*)entityName
 entityValue:(NSString*)value
   entityKey:(NSString*)key
  ignoreCase:(BOOL)ignoreCase
existsInContext:(NSManagedObjectContext*)context
{
    // Get a reference to the indicated entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    
    NSPredicate *predicate;
    
    if (ignoreCase)
       predicate = [NSPredicate predicateWithFormat:@"%K == [cd]%@",key, value];
    else
        predicate = [NSPredicate predicateWithFormat:@"%K == [c]%@",key, value];
    
    // Create and configure a select request against that entity.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    // Execute the request.
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (error)
    {
        SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
    }
    
    // Clean up and return the results.
    
    if(results.count > 0)
        return [results objectAtIndex:0];
    return nil;
}

+(id) entity:(NSString*)entityName
 entityValueNumber:(NSNumber*)value
   entityKey:(NSString*)key
existsInContext:(NSManagedObjectContext*)context
{
    // Get a reference to the indicated entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",key, value];
    
    // Create and configure a select request against that entity.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    // Execute the request.
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (error)
    {
        SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
    }
    
    // Clean up and return the results.
    
    if(results.count > 0)
        return [results objectAtIndex:0];
    return nil;
    
}

+(id) entity:(NSString*)entityName existsInContext:(NSManagedObjectContext*)context
{
    // Get a reference to the indicated entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    
    // Create and configure a select request against that entity.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    
    // Execute the request.
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (error)
    {
        SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
    }
    
    // Clean up and return the results.
    
    if(results.count > 0)
        return [results objectAtIndex:0];
    return nil;
}



+ (NSArray *)entities:(NSString *)entityName
        withPredicate:(NSPredicate *)predicate
             sortedBy:(NSArray *)sortDescriptors
              limited:(NSInteger)count
            inContext:(NSManagedObjectContext*)context
{
  if (!entityName)
  {
    SONLog(@"ERROR: Called with a nil entityName.");
    return [NSArray arrayWithObjects:nil];
  }
  // Get a reference to the indicated entity.
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:context];
  
  
  // Create and configure a select request against that entity.
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = entity;
  request.predicate = predicate;
  request.sortDescriptors = sortDescriptors;
  if(count > 0)
  {
    request.fetchLimit = count;
  }
  // Execute the request.
  NSError *error = nil;
  NSMutableArray *results = [[context executeFetchRequest:request
                                                    error:&error] mutableCopy];
  if (error)
  {
    SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
  }
  
  // Clean up and return the results.
  return results;
}

+ (NSArray *) entities:(NSString *)entityName
               ForKeys:(NSArray *)keys
             entityKey:(NSString *)keyName
         objectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
  [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(%K IN %@)",keyName, keys]];
  [fetchRequest setSortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:keyName ascending:YES] ]];
  
  // Execute the fetch.
  NSError *error;
  NSArray *existingObjects = [context executeFetchRequest:fetchRequest error:&error];
  return existingObjects;
}


+(NSArray *) absentEntities:(NSString *)entityName ForKeys:(NSArray *)keys entityKey:(NSString *)keyName objectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"NOT (%K IN %@)",keyName, keys]];
    [fetchRequest setSortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:keyName ascending:YES] ]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *existingObjects = [context executeFetchRequest:fetchRequest error:&error];
    return existingObjects;
}

+ (BOOL)entitiesExists:(NSString *)entityName
             inContext:(NSManagedObjectContext*)context
{
    if (!entityName)
    {
        SONLog(@"ERROR: Called with a nil entityName.");
        return FALSE;
    }
    // Get a reference to the indicated entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    
    
    // Create and configure a select request against that entity.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.includesPropertyValues = NO;
    request.resultType = NSManagedObjectIDResultType;

    // Execute the request.
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request
                                                      error:&error];
    if (error)
    {
        SONLog(@"Failed to select from the %@ entity: %@", entityName, [error description]);
    }
    
    // Clean up and return the results.
    return ([results count] > 0);
}
@end
