//
//  APIService+Search.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIService.h"
#import "SearchEarthquakeParameters.h"
#import "SearchEarthquakeResults.h"

@interface APIService (Search)

-(NSURLSessionDataTask*)searchEarthquakes:(SearchEarthquakeParameters*) parameters
                               completion:(void (^)(NSError *error, SearchEarthquakeResults* result))completion;

@end
