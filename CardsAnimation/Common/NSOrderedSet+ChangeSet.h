//
//  NSOrderedSet+addObject.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOrderedSet (ChangeSet)

- (NSOrderedSet*)orderedSetByAddingObject:(id)object;
- (NSOrderedSet*)orderedSetByAddingObjectsFromArray:(NSArray*)objects;
- (NSOrderedSet*)orderedSetByRemovingObject:(id)object;
- (NSOrderedSet*)orderedSetByRemovingObjectsFromArray:(NSArray*)objects;

@end
