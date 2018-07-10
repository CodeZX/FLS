//
//  FLSHelpViewController.m
//  FLS
//
//  Created by 周鑫 on 2018/7/9.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "FLSHelpViewController.h"

@interface FLSHelpViewController ()

@end

@implementation FLSHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title  = @"帮助";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
   

    UINavigationBar *bar = [[UINavigationBar alloc]init];
}

- (void)cancel:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
