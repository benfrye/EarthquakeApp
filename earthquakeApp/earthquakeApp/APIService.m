//
//  APIService.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "NSObject+Injectable.h"

#import "APIService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

NSString* const APIServiceStatusChangeNotification = @"APIServiceStatusChangeNotification";

@implementation APIService

-(instancetype)initWithBaseURL:(NSURL *)hostURL
                        prefix:(NSString*)prefix
          sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:hostURL sessionConfiguration:configuration];
    if (self != nil) {
        self.urlPrefix = prefix;
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"usgs.gov"];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:APIServiceStatusChangeNotification object:nil];
    }];
    [self.reachabilityManager startMonitoring];
    
    AFJSONResponseSerializer* jsonSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPResponseSerializer* httpSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer, httpSerializer]];
    
    AFHTTPRequestSerializer* requestSerializer = [AFHTTPRequestSerializer serializer];
    
    self.requestSerializer = requestSerializer;
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (NSURLSessionDataTask *)GET:(NSString *)apiEndpoint
                   parameters:(id)parameters
                   completion:(APIServiceCompletionBlock)completion

{
    NSDate* startTime = [NSDate date];
    NSString* urlString = [self.urlPrefix stringByAppendingString:apiEndpoint];
    
    
    NSURLSessionDataTask *dataTask =
    [self customDataTaskWithHTTPMethod:@"GET"
                             URLString:urlString
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSTimeInterval interval = [startTime timeIntervalSinceNow];
         NSLog(@"GET %@ took %0.2f seconds", urlString, -interval);
         completion(nil, responseObject);
     }
                               failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         completion(error, responseObject);
     }];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)customDataTaskWithHTTPMethod:(NSString *)method
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                                               success:(void (^)(NSURLSessionDataTask *, id))success
                                               failure:(void (^)(NSURLSessionDataTask *, NSError *, id))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        NSLog(@"Request failed with serialization error: %@", serializationError);
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error)
    {
        if (error)
        {
            if (failure)
            {
                failure(dataTask, error, responseObject);
            }
        }
        else
        {
            if (success)
            {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

@end
