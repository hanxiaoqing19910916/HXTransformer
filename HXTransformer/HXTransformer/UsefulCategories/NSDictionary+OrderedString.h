//
//  NSDictionary+OrderedString.h
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/20.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OrderedString)
/**
 *  把请求参数json 字典 转成格式化字符串
 *  如 OnReward|130000001|1|10037|1457072678|100|2|item1|1
 */
- (NSString *)paramsForOrderedString;

/**
 *  校验
 *
 *  @param key 私钥
 *
 *  @return 校验后的参数字典
 */
- (NSDictionary *)ecodeParamWithKey:(NSString *)key;

@end
