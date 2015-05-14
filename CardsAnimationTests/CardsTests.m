//
//  CardsTests.m
//  CardsAnimation
//
//  Created by Prasad CM on 14/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Cards+CardsAnimation.h"
#import "DBManager.h"

@interface CardsTests : XCTestCase

@property(nonatomic, strong) NSManagedObjectContext *moc;
@property(nonatomic, strong) Cards *card;
@end

@implementation CardsTests

- (void)setUp {
    [super setUp];

    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
    
    // Initialize card
    self.card = [CardsTests sampleCard:self.moc];
}

- (void)tearDown {

    [super tearDown];
    self.moc = nil;
    self.card = nil;
    [[DBManager sharedDBManager] resetContext:NO];
}

- (void)testUpdateCard {
    NSDictionary* dictionary = @{@"cardId": @200,
                                      @"cardUrl": @"cards_2.png",
                                      @"shouldShare": @false
                                      };
    
    // Private method but we can still test it
    [self.card refreshFromDictionary:dictionary];
    
    XCTAssertEqual([self.card.cardId intValue], 200, @"This should have been updated by the refresh method");
    XCTAssertEqualObjects(self.card.cardUrl, @"cards_2.png", @"This should have been updated by the refresh method");
    XCTAssertEqual(self.card.shouldShare, @false, @"This should have been updated by the refresh method");
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

+ (Cards *)sampleCard:(NSManagedObjectContext*)moc {
    Cards* card = [NSEntityDescription insertNewObjectForEntityForName:@"Cards" inManagedObjectContext:moc];
    
    card.cardId = @100;
    card.cardUrl = @"cards_1.png";
    card.shouldShare = @false;
    
    return card;
}

@end
