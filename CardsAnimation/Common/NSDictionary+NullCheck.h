//
//  NSDictionary+NullCheck.h
//  ReusableAssets
//
//  Created by Prasad CM on 17/01/13.
//  Copyright (c) 2013 Sonata Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullCheck)

- (id)objectForKeyWithNullCheck:(id)aKey;

@end
