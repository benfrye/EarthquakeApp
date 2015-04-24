//
//  NSObject+Injectable.m
//  WyndhamRewards
//
//  Created by MattBaranowski on 2/17/15.
//  Copyright (c) 2015 Willowtree. All rights reserved.
//

#import "NSObject+Injectable.h"

@implementation NSObject (Injectable)

+(instancetype)injected { return[[JInjector defaultInjector] objectForClass:[self class]]; }

@end
