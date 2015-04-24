//
//  Epicenter.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/21/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SearchEarthquakeResults.h"


@interface Epicenter : NSManagedObject

@property (nonatomic, retain) NSString * alert;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * magnitude;
@property (nonatomic, retain) NSNumber * time;

+(Epicenter*)fromAPIResults:(EarthquakeFeatures*)feature inContext:(NSManagedObjectContext*)context;

@end
