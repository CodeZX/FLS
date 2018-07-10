//
//  FLSSignView.m
//  FLS
//
//  Created by 周鑫 on 2018/7/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "FLSSignView.h"
#import "signModel.h"


@interface FLSSignView ()
@property (weak, nonatomic) IBOutlet UILabel *yangli;
@property (weak, nonatomic) IBOutlet UILabel *yinli;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *poem;
@property (weak, nonatomic) IBOutlet UILabel *frontLabel;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel1;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel2;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel3;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel4;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel5;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel6;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel7;


@end
@implementation FLSSignView


- (IBAction)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeSignView:)]) {
        [self.delegate closeSignView:self];
    }
}
- (IBAction)shares:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(shareSignView:)]) {
        [self.delegate shareSignView:self];
    }
   
  
    
}
- (IBAction)save:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(saveToPhotosAlbumSignView:)]) {
        [self.delegate saveToPhotosAlbumSignView:self];
    }
}





- (void)setModel:(signModel *)model {
    _model = model;
    self.yangli.text = model.date;
    self.yinli.text = model.lunar;
    self.poem.text = model.suit;
    
    if (model.lotteryNumber.count > 0) {
        self.numberLabel1.text = model.lotteryNumber[0];
        self.numberLabel2.text = model.lotteryNumber[1];
        self.numberLabel3.text = model.lotteryNumber[2];
        self.numberLabel4.text = model.lotteryNumber[3];
        self.numberLabel5.text = model.lotteryNumber[4];
        self.numberLabel6.text = model.lotteryNumber[5];
        self.numberLabel7.text = model.lotteryNumber[6];
    }
    
    NSString  *weekString =  [self getweekDayWithDate:[NSDate date]];
    switch ([weekString intValue]) {
        case 1:
             self.week.text = [NSString stringWithFormat:@"星期%@",@"日"];
            break;
        case 2:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"一"];
            break;
        case 3:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"二"];
            break;
        case 4:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"三"];
            break;
        case 5:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"四"];
            break;
        case 6:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"五"];
            break;
        case 7:
            self.week.text = [NSString stringWithFormat:@"星期%@",@"六"];
            break;
       
        default:
            break;
    }
   
    
//    NSLog(@"weakSring%@",weekString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd";
    self.day.text = [formatter stringFromDate:[NSDate date]];
}


- (id) getweekDayWithDate:(NSDate *) date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday]);
    
}


/**
 普通的截图
 该API仅可以在未使用layer和OpenGL渲染的视图上使用
 
 @return 截取的图片
 */
- (UIImage *)nomalSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end
