//
//  Epicenter.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/28/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SearchEarthquakeResults.h"


@interface Epicenter : NSManagedObject

@property (nonatomic, strong) NSString * alert;
@property (nonatomic, strong) NSNumber * depth;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * magnitude;
@property (nonatomic) int64_t time;

+(Epicenter*)fromAPIResults:(EarthquakeFeatures*)feature inContext:(NSManagedObjectContext*)context;

@end
