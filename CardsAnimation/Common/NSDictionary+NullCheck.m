//
//  NSDictionary+NullCheck.m
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import "NSDictionary+NullCheck.h"

@implementation NSDictionary (NullCheck)

- (id)objectForKeyWithNullCheck:(id)aKey{
    id temp = [self objectForKey:aKey];
    return ([temp isEqual:[NSNull null]]) ? nil : temp;
}

@end
