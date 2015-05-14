//
//  TripInfo+CardsAnimation.m
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "TripInfo+CardsAnimation.h"
#import "NSDictionary+NullCheck.h"
#import "Cards+CardsAnimation.h"
#import "DBManager.h"
#import "NSManagedObject+FetchEntity.h"

@implementation TripInfo (CardsAnimation)

-(void)refreshFromDictionary:(NSDictionary *)dictionary
{
    [self setValue:[dictionary objectForKeyWithNullCheck:@"tripId"] forKey:@"tripId"];
    [self setValue:[dictionary objectForKeyWithNullCheck:@"temperature"] forKey:@"temperature"];
    [self setValue:[dictionary objectForKeyWithNullCheck:@"daysToGo"] forKey:@"daysToGo"];
    [self setValue:[dictionary objectForKeyWithNullCheck:@"location"] forKey:@"location"];
    [self setValue:[dictionary objectForKeyWithNullCheck:@"weather"] forKey:@"weather"];

    // Recreate the cards
    for(Cards * card in self.cards) {
        [self.managedObjectContext deleteObject:card];
        [self removeCardsObject:card];
    }
    NSArray *cards = [dictionary objectForKeyWithNullCheck:@"cards"];
    for(NSDictionary * cardDict in cards) {
        Cards *card = (Cards *)[NSEntityDescription insertNewObjectForEntityForName:@"Cards" inManagedObjectContext:self.managedObjectContext];
        [card refreshFromDictionary:cardDict];
        [self addCardsObject:card];
    }
}

+ (TripInfo *) tripInfo {
    NSManagedObjectContext *context = [DBManager sharedDBManager].managedObjectContext;
    TripInfo *tripInfo = (TripInfo *)[NSManagedObject entity:@"TripInfo" existsInContext:context];
    return tripInfo;
}

@end
