//
//  TripInfo+CardsAnimation.h
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "TripInfo.h"
#import "ManagedObjectProtocol.h"

@interface TripInfo (CardsAnimation) <ManagedObjectProtocol>

+ (TripInfo *) tripInfo;
@end
