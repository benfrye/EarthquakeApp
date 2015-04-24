//
//  SearchEarthquakesParameters.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "JSONModel.h"

@interface SearchEarthquakeParameters : JSONModel
@property (nonatomic) NSString* format;
@property (nonatomic) NSString* starttime;
@property (nonatomic) NSString* endtime;
@property (nonatomic) NSInteger minmagnitude;

+(instancetype)initWithDefaults;

@end
