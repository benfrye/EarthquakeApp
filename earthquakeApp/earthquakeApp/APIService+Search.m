//
//  APIService+Search.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "APIService+Search.h"

@implementation APIService (Search)

-(NSURLSessionDataTask*)searchEarthquakes:(SearchEarthquakeParameters*) parameters
                               completion:(void (^)(NSError *error, SearchEarthquakeResults* result))completion
{
    return [self GET:@"/query"
          parameters:[parameters toDictionary]
          completion:^(NSError *error, NSDictionary *jsonResult)
            {
                if (error)
                {
                    NSLog(@"Error getting data from API: %@", error);
                }
                else
                {
                    SearchEarthquakeResults* result = [[SearchEarthquakeResults alloc]
                                                       initWithDictionary:jsonResult error:&error];
                    if (error)
                    {
                        NSLog(@"Err: %@", error);
                    }
                    if (completion)
                    {
                        completion(error, result);
                    }
                }
            }];
}

@end
