//
//  UITextField+MaxLength.h
//  XWZeno
//
//  Created by jason on 2018/6/25.
//  Copyright © 2018年 AndyLi. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UITextField (MaxLength)

/**
 最大长度
 */
@property (assign, nonatomic) IBInspectable NSUInteger maxLength;

/**
 整数位数
 */
@property (assign, nonatomic) IBInspectable NSUInteger maxIntLength;

/**
 小数位数 当设置了整数位数时表明支持 小数 没有设置小数位则默认支持2位
 */
@property (assign, nonatomic) IBInspectable NSUInteger maxDecimalLength;

@end
