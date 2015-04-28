//
//  MapViewController.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/21/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "MapViewController.h"
#import "MKCircle+Magnitude.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    int CIRCLE_RADIUS_MULTIPLIER;
}

- (void)viewDidLoad {
    CIRCLE_RADIUS_MULTIPLIER = 20000;
    
    [super viewDidLoad];
    
    if (self.allEpicenters)
    {
        CLLocationCoordinate2D epicenterCoord;
        for (Epicenter *epicenter in self.allEpicenters)
        {
            epicenterCoord.latitude = [epicenter.latitude floatValue];
            epicenterCoord.longitude = [epicenter.longitude floatValue];
            
            MKCircle *radius = [MKCircle
                                circleWithCenterCoordinate:epicenterCoord
                                radius:[epicenter.magnitude intValue] * CIRCLE_RADIUS_MULTIPLIER];
            radius.magnitude = epicenter.magnitude;
            [self.earthquakeMapView addOverlay:radius];
        }
        
        if ([self.allEpicenters count] == 1) {
            MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(epicenterCoord,
                                                                              2000000,
                                                                              2000000);
            [self.earthquakeMapView setRegion:newRegion];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        
        NSArray *magnitudeColors = @[[UIColor blueColor],    // Mag 0-2
                                     [UIColor greenColor],   // Mag 3-4
                                     [UIColor yellowColor],  // Mag 5-6
                                     [UIColor orangeColor],  // Mag 7-8
                                     [UIColor redColor]];    // Mag 9+
        // subtract .5 to scale up on odd numbers instead of even
        int colorIndex = (int)(([[(MKCircle*)overlay magnitude] intValue] - .5)/2);
        if (colorIndex >= [magnitudeColors count])
        {
            colorIndex = (int)[magnitudeColors count] - 1;
        }

        UIColor* fillColor = [magnitudeColors objectAtIndex:colorIndex];
        circleRenderer.strokeColor = fillColor;
        circleRenderer.fillColor = [fillColor colorWithAlphaComponent:0.3];
        return circleRenderer;
    }
    return nil;
}

@end
