//
//  NSString+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
#import "NSDate+Extension.h"
@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

/** 计算当前文件\文件夹的内容大小 */
- (NSInteger)fileSize;
/** 判断是否是手机号 */
- (BOOL)isMobileNumber;

- (NSString *)formatDateString;

@end
