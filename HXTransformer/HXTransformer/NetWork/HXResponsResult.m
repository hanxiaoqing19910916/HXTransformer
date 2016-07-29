//
//  HXResponsResult.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/25.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXResponsResult.h"

@implementation HXResponsResult

//+ (instancetype)resultWithTaskID:(NSNumber *)taskID responseObject:(id)respObject request:(NSURLRequest *)request error:(NSError *)error {
//    
//    
//}


- (instancetype)initWithTaskID:(NSNumber *)taskID responseObject:(id)respObject request:(NSURLRequest *)request error:(NSError *)error
{
    self = [super init];
    if (self) {
        _taskID = taskID;
        _respObject = respObject;
        _resError = error;
        _status = [self statusWithError:error];
        
    }
    return self;
}


- (instancetype)initWithTaskID:(NSNumber *)taskID responseObject:(id)respObject request:(NSURLRequest *)request status:(HXResponsStatus)status
{
    self = [super init];
    if (self) {
        _taskID = taskID;
        _respObject = respObject;
        _status = status;
    }
    return self;
}


- (HXResponsStatus)statusWithError:(NSError *)error {
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            return HXResponsStatusTimeout;
        } else {
            return HXResponsStatusErrorNoNetwork;
        }
    }
    return HXResponsStatusSuccess;
}



@end
