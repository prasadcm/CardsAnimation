//
//  ManagedObjectProtocol.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ManagedObjectProtocol <NSObject>

@optional
+(NSString*)sDataKey;
+(NSString*)sDataEntity;
+(NSString*)coreDataKey;
+(NSString*)coreDataEntity;
+(NSDictionary*)fieldMap;
+(NSManagedObject*)createFromDictionary:(NSDictionary*)dictionary withContext:(NSManagedObjectContext*)context;
-(void)refreshFromDictionary:(NSDictionary*)dictionary;
-(BOOL)okToDelete;
+(BOOL)canDeleteRecord:(NSDictionary*)dictionary;

@end
