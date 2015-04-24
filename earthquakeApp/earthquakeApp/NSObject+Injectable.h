//
//  NSObject+Injectable.h
//  WyndhamRewards
//
//  Created by MattBaranowski on 2/17/15.
//  Copyright (c) 2015 Willowtree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JInjector.h>

@interface NSObject (Injectable) <JInjectable>

+(instancetype)injected;

@end
