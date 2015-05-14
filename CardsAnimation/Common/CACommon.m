//
//  CACommon.m
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "CACommon.h"
#import "DBManager.h"
#import "NSManagedObject+FetchEntity.h"
#import "ManagedObjectProtocol.h"
#import "NSDictionary+NullCheck.h"

@implementation CACommon

+ (NSString *) galleryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentDBFolderPath = [documentsDirectory stringByAppendingPathComponent:@"trip.gallery"];
    return documentDBFolderPath;
}

- (NSDictionary *) JSONDictionary {
    
    NSString *fileName = @"TripDetails.json";
    NSString *galleryPath = [CACommon galleryPath];
    NSURL *galleyURL = [NSURL fileURLWithPath:galleryPath isDirectory:YES];
    NSString *jsonPath = [[galleyURL URLByAppendingPathComponent:fileName] path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *jsonDict = nil;
    
    if ([fileManager fileExistsAtPath:jsonPath]) {
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
        NSError *jsonError;
        jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        SONLog(@"%@",jsonDict);
    } else {
        NSError *error;
        [fileManager removeItemAtPath:galleryPath error:&error];
    }
    return jsonDict;
}

- (void) loadTripDetails {
    
    NSDictionary *jsonDict = [self JSONDictionary];
    NSDictionary *tripDict;
    
    if (jsonDict) {
        tripDict= [jsonDict objectForKeyWithNullCheck:@"tripDetails"];
    }
    
    if (tripDict) {
        
        DBManager *dbManager = [DBManager sharedDBManager];
        NSManagedObjectContext *context = [dbManager managedObjectContext];
        
        NSNumber *tripId = [tripDict objectForKeyWithNullCheck:@"tripId"];
        if ([tripId intValue] > 0) {
            [context performBlockAndWait:^(void)
             {
                 @try {
                     NSManagedObject<ManagedObjectProtocol> *managedObject = [NSManagedObject entity:@"TripInfo"
                                                                                   entityValueNumber:tripId
                                                                                           entityKey:@"tripId"
                                                                                     existsInContext:context];
                     if (managedObject == nil) {
                         managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"TripInfo" inManagedObjectContext:context];
                     }
                     [managedObject refreshFromDictionary:tripDict];
                     NSError *error;
                     [context save:&error];
                 }
                 @catch (NSException *exception) {
                     SONLog(@"%@",exception.description);
                 }
             }];
            
        }
    }
}

@end
