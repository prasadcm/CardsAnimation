//
//  Cards.h
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TripInfo;

@interface Cards : NSManagedObject

@property (nonatomic, retain) NSString * cardUrl;
@property (nonatomic, retain) NSNumber * shouldShare;
@property (nonatomic, retain) NSNumber * cardId;
@property (nonatomic, retain) TripInfo *trip;

@end
