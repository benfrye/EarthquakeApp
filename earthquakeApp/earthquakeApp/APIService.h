//
//  APIService.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

extern NSString* const APIServiceStatusChangeNotification;

typedef void (^APIServiceCompletionBlock)(NSError *error, NSDictionary* result);

@interface APIService : AFHTTPSessionManager

@property (nonatomic) NSString* urlPrefix;

-(instancetype)initWithBaseURL:(NSURL *)hostURL
                        prefix:(NSString*)prefix
          sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionDataTask *)GET:(NSString *)apiEndpoint
                   parameters:(id)parameters
                   completion:(APIServiceCompletionBlock)completion;

@end
