//
//  NSOrderedSet+addObject.m
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import "NSOrderedSet+ChangeSet.h"

@implementation NSOrderedSet (ChangeSet)

- (NSOrderedSet*)orderedSetByAddingObject:(id)object
{
  NSMutableOrderedSet* orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
  [orderedSet addObject:object];
  return orderedSet;
}

- (NSOrderedSet*)orderedSetByAddingObjectsFromArray:(NSArray*)objects
{
  NSMutableOrderedSet* orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
  [orderedSet addObjectsFromArray:objects];
  return orderedSet;
}

- (NSOrderedSet*)orderedSetByRemovingObject:(id)object{
  NSMutableOrderedSet* orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
  [orderedSet removeObject:object];
  return orderedSet;
}

- (NSOrderedSet*)orderedSetByRemovingObjectsFromArray:(NSArray*)objects
{
  NSMutableOrderedSet* orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
  [orderedSet removeObjectsInArray:objects];
  return orderedSet;
}

@end
