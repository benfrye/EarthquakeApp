//
//  SearchEarthquakeResults.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface EarthquakeFeatureProperties : JSONModel
@property (nonatomic) NSNumber* mag;
@property (nonatomic) NSNumber* time;
@property (nonatomic) NSString<Optional>* alert;
//Unused but available properties
//@property (nonatomic) NSString* title;
//@property (nonatomic) NSString* place;
//@property (nonatomic) NSNumber* updated;
//@property (nonatomic) NSNumber* tz;
//@property (nonatomic) NSString* url;
//@property (nonatomic) NSString* detail;
//@property (nonatomic) NSNumber* felt;
//@property (nonatomic) NSNumber* cdi;
//@property (nonatomic) NSNumber* mmi;
//@property (nonatomic) NSString* status;
//@property (nonatomic) NSNumber* tsunami;
//@property (nonatomic) NSNumber* sig;
//@property (nonatomic) NSString* net;
//@property (nonatomic) NSString* code;
//@property (nonatomic) NSString* ids; //String representation of comma-separated list of event IDs...ew
//@property (nonatomic) NSString* sources;
//@property (nonatomic) NSString* types;
//@property (nonatomic) NSNumber* nst;
//@property (nonatomic) NSNumber* dmin;
//@property (nonatomic) NSNumber* rms;
//@property (nonatomic) NSNumber* gap;
//@property (nonatomic) NSString* magType;
//@property (nonatomic) NSString* type; 
@end

@interface GeometryCoordinates : JSONModel
@property (nonatomic) NSNumber* longitude;
@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* depth;
@end

@interface EarthquakeFeatureGeometry : JSONModel
@property (nonatomic) NSString* type;
@property (nonatomic) NSArray* coordinates; //@[longitude, latitude, depth]
@end

@protocol EarthquakeFeatures <NSObject>
@end
@interface EarthquakeFeatures : JSONModel
@property (nonatomic) NSString* type;
@property (nonatomic) EarthquakeFeatureProperties* properties;
@property (nonatomic) EarthquakeFeatureGeometry* geometry;
@property (nonatomic) NSString* _id; //remap to id
@end

@interface SearchEarthquakeResults : JSONModel
@property (nonatomic) NSString* type;
@property (nonatomic) NSArray<EarthquakeFeatures>* features;
@end
