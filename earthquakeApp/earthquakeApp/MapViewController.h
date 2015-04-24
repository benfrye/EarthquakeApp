//
//  MapViewController.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/21/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Epicenter.h"


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property NSMutableArray* allEpicenters;

@property (weak, nonatomic) IBOutlet MKMapView *earthquakeMapView;

@end
