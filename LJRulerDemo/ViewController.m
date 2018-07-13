//
//  ViewController.m
//  LJRulerDemo
//
//  Created by liujun on 2018/7/13.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "ViewController.h"
#import "LJRuler.h"

@interface ViewController () <LJRulerDelegate>

@property (nonatomic, strong) LJRuler *ruler;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:20.f];
    self.textLabel.text = @"当前刻度值:20";
    self.textLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 20 * 2, 40);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
    
    self.ruler = [[LJRuler alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, 44)];
    self.ruler.rulerColor = [UIColor whiteColor];
    self.ruler.delegate = self;
    self.ruler.scaleCount = 700;
    self.ruler.scaleAverage = 1;
    self.ruler.currentValue = 1;
    [self.view addSubview:self.ruler];
}

- (void)ruler:(LJRuler *)ruler didScroll:(LJRulerScrollView *)scrollView {
    self.textLabel.text = [NSString stringWithFormat:@"当前刻度值: %.1f", scrollView.currentValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.ruler.currentValue = 200;
}

@end
