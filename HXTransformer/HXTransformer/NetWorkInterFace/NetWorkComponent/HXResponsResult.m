//
//  HXResponsResult.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/25.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXResponsResult.h"

@implementation HXResponsResult


+ (instancetype)errorResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request error:(NSError *)error {
    HXResponsResult *result = [[self alloc] init];
    [result setValue:taskID forKey:@"taskID"];
//  [result setValue:request forKey:@"request"];
     [result setValue:error forKey:@"resError"];
    result.status = [self statusWithError:error];
    return result;
}


+ (instancetype)successResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request responseObject:(id)respObject {
    HXResponsResult *result = [[self alloc] init];
    [result setValue:taskID forKey:@"taskID"];
//  [result setValue:request forKey:@"request"];
    [result setValue:respObject forKey:@"respObject"];
    result.status = HXResponsStatusSuccess;
    return result;
}


+ (HXResponsStatus)statusWithError:(NSError *)error {
    if (error.code == NSURLErrorTimedOut) {
        return HXResponsStatusTimeout;
    } else {
        return HXResponsStatusErrorNoNetwork;
    }
}

- (id)json_obj {
    if ([_respObject isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)_respObject) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([_respObject isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)_respObject options:kNilOptions error:nil];
    }
    return nil;
}



@end
