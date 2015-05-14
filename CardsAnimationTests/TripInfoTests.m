//
//  TripInfoTests.m
//  CardsAnimation
//
//  Created by Prasad CM on 14/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Cards+CardsAnimation.h"
#import "TripInfo+CardsAnimation.h"
#import "DBManager.h"
#import "CACommon.h"

@interface TripInfoTests : XCTestCase

@property(nonatomic, strong) NSManagedObjectContext *moc;
@property(nonatomic, strong) TripInfo *tripInfo;
@end

@implementation TripInfoTests

- (void)setUp {
    [super setUp];
    
    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
    
    // Initialize trip info
    self.tripInfo = [TripInfoTests sampleTripInfo:self.moc];
}

- (void)tearDown {
    
    [super tearDown];
    self.moc = nil;
    self.tripInfo = nil;
    [[DBManager sharedDBManager] resetContext:NO];
}

- (void)testUpdateTripInfo {
    
    
    NSDictionary* cardDict = @{@"cardId": @200,
                                 @"cardUrl": @"cards_2.png",
                                 @"shouldShare": @false
                                 };
    
    NSArray *cardsArray = @[cardDict];
    
    NSDictionary* tripDict = @{@"tripId" : @20,
                               @"daysToGo" : @10,
                               @"temperature" : @36,
                               @"weather" : @1,
                               @"location" : @"Greece",
                               @"cards" : cardsArray
                               };
    
    // Private method but we can still test it
    [self.tripInfo refreshFromDictionary:tripDict];
    
    XCTAssertEqual([self.tripInfo.tripId intValue], 20, @"This should have been updated by the refresh method");
    XCTAssertEqual([self.tripInfo.daysToGo intValue], 10, @"This should have been updated by the refresh method");
    XCTAssertEqual([self.tripInfo.weather intValue], 1, @"This should have been updated by the refresh method");
    XCTAssertEqualObjects(self.tripInfo.location, @"Greece", @"This should have been updated by the refresh method");
}

+ (TripInfo *)sampleTripInfo:(NSManagedObjectContext*)moc {
    Cards* card1 = [NSEntityDescription insertNewObjectForEntityForName:@"Cards" inManagedObjectContext:moc];
    
    TripInfo* trip1 = [NSEntityDescription insertNewObjectForEntityForName:@"TripInfo" inManagedObjectContext:moc];
    
    NSString *galleryPath = [CACommon galleryPath];
    NSURL *galleryURL = [NSURL URLWithString:galleryPath];
    NSString *filePath = [[galleryURL URLByAppendingPathComponent:@"cards_1.png"] path];
    
    card1.cardId = @100;
    card1.cardUrl = filePath;
    card1.shouldShare = @false;
    
    trip1.temperature = [[NSDecimalNumber alloc]initWithInt:38];
    trip1.daysToGo = @100;
    trip1.location = @"India";
    trip1.tripId = @10;
    [trip1 addCardsObject:card1];
    trip1.weather = @1;
    
    return trip1;
}
@end
