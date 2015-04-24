//
//  MKCircleRenderer+Magnitude.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/24/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "MKCircle+Magnitude.h"
#import <objc/runtime.h>

@implementation MKCircle (Magnitude)
@dynamic magnitude;

-(void)setMagnitude:(NSNumber *)newMagnitude
{
    objc_setAssociatedObject(self, @selector(magnitude), newMagnitude, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSNumber*)magnitude
{
    return objc_getAssociatedObject(self, @selector(magnitude));
}

@end
