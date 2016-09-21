//
//  NSArray+ToFormatString.h
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ToFormatString)

/**
 *  把数组里面所有的字符串 逗号分割 拼接成完整一个串
 *
 *  @return 格式化字符串
 */
- (NSString *)toDotSegmentString;



/**
 *  把数组里面所有的字符串 竖线分割 拼接成完整一个串
 *
 *  @return 格式化字符串
 */
- (NSString *)toVerticalLineSegmentString;


@end
