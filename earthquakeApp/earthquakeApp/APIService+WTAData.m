//
//  APIService+WTAData.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/28/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "APIService+WTAData.h"
#import "Epicenter.h"
#import "NSObject+Injectable.h"

#import <WTAData/WTAData.h>

@implementation APIService (WTAData)

-(void)updateEarthquakes:(SearchEarthquakeParameters*) parameters
              completion:(void (^)(NSError *error))completion
{
    WTAData *dataService = [WTAData injected];
    
    [[APIService injected] searchEarthquakes:parameters
                                  completion:^(NSError *error, SearchEarthquakeResults *result)
     {
         if (!error) {
             [dataService deleteAllDataWithCompletion:^(NSError *error)
              {
                  if (error)
                  {
                      NSLog(@"Error clearing context for new save: %@", error);
                  }
                  else
                  {
                      [dataService saveInBackgroundAndWait:^(NSManagedObjectContext *context)
                       {
                           for (EarthquakeFeatures *feature in result.features)
                           {
                               [Epicenter fromAPIResults:feature inContext:context];
                           }
                       } error:&error];
                      
                      if (completion)
                      {
                          completion(error);
                      }
                  }
              }];
         }
     }];
}

@end
