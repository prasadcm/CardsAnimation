//
//  Cards+CardsAnimation.m
//  CardsAnimation
//
//  Created by Prasad CM on 13/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "Cards+CardsAnimation.h"
#import "NSDictionary+NullCheck.h"
#import "CACommon.h"

@implementation Cards (CardsAnimation)

-(void)refreshFromDictionary:(NSDictionary *)dictionary
{
    [self setValue:[dictionary objectForKeyWithNullCheck:@"cardId"] forKey:@"cardId"];
    NSString *galleryPath = [CACommon galleryPath];
    NSString *path = [dictionary objectForKeyWithNullCheck:@"cardUrl"];
    NSURL *galleryURL = [NSURL URLWithString:galleryPath];
    NSString *filePath = [[galleryURL URLByAppendingPathComponent:path] path];
    [self setValue:filePath forKey:@"cardUrl"];
    [self setValue:[dictionary objectForKeyWithNullCheck:@"shouldShare"] forKey:@"shouldShare"];
}
@end
