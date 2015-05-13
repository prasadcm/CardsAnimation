//
//  TripInfo.h
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cards;

@interface TripInfo : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * temperature;
@property (nonatomic, retain) NSNumber * weather;
@property (nonatomic, retain) NSNumber * daysToGo;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * tripId;
@property (nonatomic, retain) NSOrderedSet *cards;
@end

@interface TripInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(Cards *)value inCardsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCardsAtIndex:(NSUInteger)idx;
- (void)insertCards:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCardsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCardsAtIndex:(NSUInteger)idx withObject:(Cards *)value;
- (void)replaceCardsAtIndexes:(NSIndexSet *)indexes withCards:(NSArray *)values;
- (void)addCardsObject:(Cards *)value;
- (void)removeCardsObject:(Cards *)value;
- (void)addCards:(NSOrderedSet *)values;
- (void)removeCards:(NSOrderedSet *)values;
@end
