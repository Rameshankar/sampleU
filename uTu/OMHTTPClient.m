//
//  OMHTTPClient.m
//  Ola Mundo
//
//  Created by Sankar Dheksit on 8/13/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "OMHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSString * const kOMAPIBaseURLString = @"http://54.255.206.204:3000/";

@implementation OMHTTPClient

+ (OMHTTPClient *)sharedClient {
    static OMHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kOMAPIBaseURLString]];
    });
    _sharedClient.isMsgSent = FALSE;
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;

    return self;
}

@end
