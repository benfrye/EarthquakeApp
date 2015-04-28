//
//  Epicenter.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/28/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "Epicenter.h"
#import <NSManagedObject+WTAData.h>


@implementation Epicenter

@dynamic alert;
@dynamic depth;
@dynamic latitude;
@dynamic longitude;
@dynamic magnitude;
@dynamic time;

+(Epicenter*)fromAPIResults:(EarthquakeFeatures*)feature inContext:(NSManagedObjectContext*)context
{
    Epicenter* epicenter = [Epicenter createEntityInContext:context];
    epicenter.longitude = [feature.geometry.coordinates objectAtIndex:0];
    epicenter.latitude = [feature.geometry.coordinates objectAtIndex:1];
    epicenter.depth = [feature.geometry.coordinates objectAtIndex:2];
    
    epicenter.magnitude = feature.properties.mag;
    //convert from milliseconds to seconds
    epicenter.time = ([feature.properties.time integerValue]/1000);
    epicenter.alert = feature.properties.alert;
    return epicenter;
}

@end
