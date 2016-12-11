//
//  ViewController.m
//  LiveDemo
//
//  Created by 刘清 on 2016/12/10.
//  Copyright © 2016年 刘清. All rights reserved.
//

#import "ViewController.h"

#import "PullViewController.h"
#import "PushViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self createBT];
    
    
}

- (void)createBT{
    
    NSArray *arr = @[@"采集音频视频推流", @"拉流播放"];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.bounds = CGRectMake(0, 0, 150, 40);
        bt.center = CGPointMake(M_WIDTH / 2, 200 + 100 * i);
        [bt addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 1000 + i;
        [bt setTitle:arr[i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:bt];
    }
}

- (void)onclick:(UIButton *)bt
{
    if (bt.tag == 1000) {
        PushViewController *pvc = [[PushViewController alloc] init];
        [self presentViewController:pvc animated:NO completion:nil];
    }else{
        PullViewController *pvc = [[PullViewController alloc] init];
        [self presentViewController:pvc animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
