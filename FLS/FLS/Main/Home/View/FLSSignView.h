//
//  FLSSignView.h
//  FLS
//
//  Created by 周鑫 on 2018/7/4.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLSSignView;
@class signModel;
@protocol  FLSSignViewDelegate <NSObject>
@optional
- (void)closeSignView:(FLSSignView *)signView;
- (void)shareSignView:(FLSSignView *)signView;
- (void)saveToPhotosAlbumSignView:(FLSSignView *)signView;
@required
@end
@interface FLSSignView : UIView
@property (nonatomic,weak) id<FLSSignViewDelegate> delegate;
@property (nonatomic,strong) signModel * model;
- (UIImage *)nomalSnapshotImage;
- (void)aaaaa;
@end
