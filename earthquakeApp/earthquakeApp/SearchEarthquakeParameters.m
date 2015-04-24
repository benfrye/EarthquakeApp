//
//  SearchEarthquakesParameters.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "SearchEarthquakeParameters.h"

@implementation SearchEarthquakeParameters

+(instancetype)initWithDefaults
{
    SearchEarthquakeParameters *defaultParameters = [[SearchEarthquakeParameters alloc] init];
    defaultParameters.format = @"geojson";
    defaultParameters.starttime = @"2015-04-19";
    defaultParameters.endtime = @"2015-04-20";
    defaultParameters.minmagnitude = 1;
    return defaultParameters;
}
@end
