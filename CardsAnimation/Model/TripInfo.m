//
//  TripInfo.m
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "TripInfo.h"
#import "Cards.h"
#import "NSOrderedSet+ChangeSet.h"

@implementation TripInfo

@dynamic temperature;
@dynamic weather;
@dynamic daysToGo;
@dynamic location;
@dynamic tripId;
@dynamic cards;

- (void)addCardsObject:(Cards *)value {
    [self setCards:[[self cards] orderedSetByAddingObject:value]];
}
- (void)removeCardsObject:(Cards *)value {
    [self setCards:[[self cards] orderedSetByRemovingObject:value]];
 
}
- (void)addCards:(NSOrderedSet *)values {
    [self setCards:[[self cards] orderedSetByAddingObjectsFromArray:[values array]]];
}
- (void)removeCards:(NSOrderedSet *)values {
    [self setCards:[[self cards] orderedSetByRemovingObjectsFromArray:[values array]]];
}

@end
