//
//  CACommon.h
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

@interface CACommon : NSObject

typedef enum
{
    Summer = 1,
    Winter,
    Rainy,
    Spring,
    Autumn
} WeatherDetails;


+ (NSString *) galleryPath;
- (void) loadTripDetails;
@end
