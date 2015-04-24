//
//  SearchEarthquakeResults.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "SearchEarthquakeResults.h"

@implementation EarthquakeFeatureProperties
@end

@implementation GeometryCoordinates
@end

@implementation EarthquakeFeatureGeometry
@end

@implementation EarthquakeFeatures
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"_id"
                                                       }];
}
@end

@implementation SearchEarthquakeResults

@end
