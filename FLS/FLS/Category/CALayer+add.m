//
//  CALayer+add.m
//  FLS
//
//  Created by 周鑫 on 2018/7/5.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "CALayer+add.h"
#import <UIKit/UIKit.h>

@implementation CALayer (add)
- (void)setBorderColorWithUIColor:(UIColor *)color

{
    
    self.borderColor = color.CGColor;
    
}
@end
