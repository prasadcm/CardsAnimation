//
//  CATabBarController.m
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "CATabBarController.h"
#import "CACommon.h"

@implementation CATabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    [viewControllerArray addObject:[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController]];
    [viewControllerArray addObject:[[UIStoryboard storyboardWithName:@"Planner" bundle:nil] instantiateInitialViewController]];
    [viewControllerArray addObject:[[UIStoryboard storyboardWithName:@"Favorites" bundle:nil] instantiateInitialViewController]];
    [viewControllerArray addObject:[[UIStoryboard storyboardWithName:@"Holiday" bundle:nil] instantiateInitialViewController]];
    [viewControllerArray addObject:[[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateInitialViewController]];
    
    [self setViewControllers:viewControllerArray];
}

@end
