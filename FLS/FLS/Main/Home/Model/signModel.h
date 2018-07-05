//
//  signMdoel.h
//  FLS
//
//  Created by 周鑫 on 2018/7/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signModel : NSObject
//不宜/忌
@property (nonatomic,strong) NSString *avoid;
//查询日期
@property (nonatomic,strong) NSString *date;
//吉煞
@property (nonatomic,strong) NSString *jishen;
//农历日期
@property (nonatomic,strong) NSString *lunar;
//宜
@property (nonatomic,strong) NSString *suit;
//凶煞
@property (nonatomic,strong) NSString *xiongshen;

// 彩票号码
@property (nonatomic,strong) NSArray *lotteryNumber;

- (void)setattributeWith:(signModel *)model;
@end
