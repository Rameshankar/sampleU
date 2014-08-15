//
//  OMHTTPClient.h
//  Ola Mundo
//
//  Created by Sankar Dheksit on 8/13/13.
//  Copyright (c) 2013 olamundo. All rights reserved.
//

#import "AFHTTPClient.h"

@interface OMHTTPClient : AFHTTPClient

@property BOOL isMsgSent;

+ (OMHTTPClient *)sharedClient;

@end
