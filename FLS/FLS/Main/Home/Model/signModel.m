//
//  signMdoel.m
//  FLS
//
//  Created by 周鑫 on 2018/7/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "signModel.h"

@implementation signModel
- (void)setattributeWith:(signModel *)model {
    self.avoid = model.avoid;
    self.date = model.date;
    self.jishen = model.jishen;
    self.lunar = model.lunar;
    self.suit = model.suit;
    self.xiongshen = model.xiongshen;
    self.lotteryNumber = model.lotteryNumber;
}










////不宜/忌
//@property (nonatomic,strong) NSString *avoid;
////查询日期
//@property (nonatomic,strong) NSString *date;
////吉煞
//@property (nonatomic,strong) NSString *jishen;
////农历日期
//@property (nonatomic,strong) NSString *lunar;
////宜
//@property (nonatomic,strong) NSString *suit;
////凶煞
//@property (nonatomic,strong) NSString *xiongshen;
//
//// 彩票号码
//@property (nonatomic,strong) NSArray *lotteryNumber;
@end
