//
//  APIService+WTAData.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/28/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIService+Search.h"

@interface APIService (WTAData)

-(void)updateEarthquakes:(SearchEarthquakeParameters*) parameters
              completion:(void (^)(NSError *error))completion;

@end
