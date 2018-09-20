//
//  UITextField+MaxLength.m
//  XWZeno
//
//  Created by jason on 2018/6/25.
//  Copyright © 2018年 AndyLi. All rights reserved.
//

#import "UITextField+MaxLength.h"

#import <objc/runtime.h>

static char kMaxLength;
static char kMaxIntLength;
static char kMaxDecimalLength;

@interface UItextFieldMaxLengthObserver : NSObject

@end

@implementation UItextFieldMaxLengthObserver

- (void)textChange:(UITextField *)textField {
    NSString *destText = textField.text;
    NSUInteger maxLength = textField.maxLength;
    NSUInteger maxIntLength = textField.maxIntLength;
    NSUInteger maxDecialLength = textField.maxDecimalLength;
    if (maxIntLength > 0 && maxDecialLength <= 0) {
        maxDecialLength = 2;//默认2位小数
    }
    
    // 对中文的特殊处理，shouldChangeCharactersInRangeWithReplacementString 并不响应中文输入法的选择事件
    // 如拼音输入时，拼音字母处于选中状态，此时不判断是否超长
    UITextRange *selectedRange = [textField markedTextRange];
    if ((!selectedRange || !selectedRange.start) && (maxIntLength > 0 || maxLength > 0)) {
       
        if (maxLength > 0 && destText.length > maxLength) {
            textField.text = [destText substringToIndex:maxLength];
            
        }else if (textField.keyboardType == UIKeyboardTypeDecimalPad) {
            
            NSRange range = [destText rangeOfString:@"." options:NSBackwardsSearch];;
            //有小数 整数位大于1
            if ((range.location == 0 || range.location > 1) && range.length == 1){
                //如果第一位 是 .
                if (range.location == 0) {
                    textField.text = [destText substringToIndex:range.location];

                    //或者多位小数点
                }else if ([destText componentsSeparatedByString:@"."].count > 2) {
                    textField.text = [destText substringToIndex:range.location];
                }else{
                    
                    if(range.location > maxIntLength){
                        //插入数字在小数点前整数超限 整数输入超限
                        textField.text = [NSString stringWithFormat:@"%@%@",[destText substringToIndex:maxIntLength],[destText substringFromIndex:range.location ]];
                    }else if (destText.length - range.location > maxDecialLength){
                        //插入数字在小数点后 小数位超限制
                        textField.text = [destText substringToIndex:range.location + maxDecialLength + 1];
                    }
                
                }
                
                
            }else if (destText.length == 2) {
                //如果第一位是0只能输入 .
                if ([[destText substringToIndex:1] isEqualToString:@"0"] && ![[destText substringFromIndex:1] isEqualToString:@"."]) {
                    textField.text = [destText substringToIndex:1];
                }
                
            } else if (range.length){//正常输入有小数点
                
                if(range.location > maxIntLength){
                    //插入数字在小数点前整数超限 整数输入超限
                    textField.text = [NSString stringWithFormat:@"%@%@",[destText substringToIndex:maxIntLength],[destText substringFromIndex:range.location]];
                }else if (destText.length - range.location > maxDecialLength){
                    //插入数字在小数点后 小数位超限制
                    textField.text = [destText substringToIndex:range.location + maxDecialLength + 1];
                }
                
                
            }else if (maxIntLength > 0  && destText.length > maxIntLength) { //仅输入整数且超
                textField.text = [destText substringToIndex:maxIntLength];
            }
        
            //整数
        }else if (textField.keyboardType == UIKeyboardTypeNumberPad) {
            //如果第一位是0只能输入 自动去第一个0
            if (destText.length == 2) {
                if ([[destText substringToIndex:1] isEqualToString:@"0"] ) {
                    textField.text = [destText substringFromIndex:1];
                }
            }
        }
    }
}


@end

static UItextFieldMaxLengthObserver *observer;

@implementation UITextField (MaxLength)

@dynamic maxLength;
@dynamic maxIntLength;
@dynamic maxDecimalLength;

+ (void)load {
    observer = [[UItextFieldMaxLengthObserver alloc] init];
}


- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kMaxIntLength, @(0), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (maxLength) {
        [self addTarget:observer
                 action:@selector(textChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
}
- (void)setMaxIntLength:(NSUInteger)maxIntLength{
    objc_setAssociatedObject(self, &kMaxLength, @(0), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kMaxIntLength, @(maxIntLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (maxIntLength) {
        [self addTarget:observer
                 action:@selector(textChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)setMaxDecimalLength:(NSUInteger)maxDecimalLength{
    objc_setAssociatedObject(self, &kMaxDecimalLength, @(maxDecimalLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maxDecimalLength) {
        [self addTarget:observer
                 action:@selector(textChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
}

-(NSUInteger)maxLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxLength);
    return [number integerValue];
}

-(NSUInteger)maxIntLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxIntLength);
    return [number integerValue];
}

-(NSUInteger)maxDecimalLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxDecimalLength);
    return [number integerValue];
}

@end
