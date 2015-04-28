//
//  AppDelegate.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "AppDelegate.h"
#import "APIService.h"

#import "NSObject+Injectable.h"

#import <JInjector.h>
#import <WTAData.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Configure WTAData
    WTADataConfiguration* config = [WTADataConfiguration
                                    defaultConfigurationWithModelNamed:@"earthquakeApp"];
    config.shouldDeleteStoreFileOnModelMismatch = YES;
    config.shouldDeleteStoreFileOnIntegrityErrors = YES;
    WTAData* dataStore = [[WTAData alloc] initWithConfiguration:config];
    [[JInjector defaultInjector] setObject:dataStore forClass:[WTAData class]];
    
    //Configure API Client
    APIService* apiService = [[APIService alloc]
                              initWithBaseURL:[NSURL URLWithString:@"http://earthquake.usgs.gov"]
                              prefix:@"/fdsnws/event/1"
                              sessionConfiguration:[NSURLSessionConfiguration
                                                    defaultSessionConfiguration]];
    [[JInjector defaultInjector] setObject:apiService forClass:[APIService class]];
    
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
@end
