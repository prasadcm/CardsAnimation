//
//  CAAppDelegate.m
//  CardsAnimation
//
//  Created by Prasad CM on 12/05/15.
//  Copyright (c) 2015 Sonata Software Limited. All rights reserved.
//

#import "CAAppDelegate.h"
#import "CATabBarController.h"
#import "CACommon.h"

@interface CAAppDelegate ()

@end

@implementation CAAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self copyResources];
    CACommon *caCommon = [[CACommon alloc] init];
    [caCommon loadTripDetails];
    
    CATabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) copyResources {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *galleryPath = [CACommon galleryPath];
    BOOL success = [fileManager fileExistsAtPath:galleryPath];
    BOOL isDir=FALSE;
    
    if (success){
        SONLog(@"Files already copied!");
    } else {
        NSError *error;
        NSString * resourceDBFolderPath = [[NSBundle mainBundle] pathForResource:@"trip" ofType:@"gallery"];
        [fileManager copyItemAtPath:resourceDBFolderPath toPath:galleryPath
                              error:&error];
        if ([ fileManager fileExistsAtPath:galleryPath isDirectory:&isDir])
        {
            if (error || !isDir)
            {
                SONLog(@"Could not remove old files. Error:%@", [error localizedDescription]);
                [fileManager removeItemAtPath:galleryPath error:&error];
                return;
            }
        }
    }
}
@end
