//
//  LJRulerScrollView.h
//  LJRulerDemo
//
//  Created by liujun on 2018/7/13.
//  Copyright © 2018年 liujun. All rights reserved.
// * 滚动刻度尺

#import <UIKit/UIKit.h>

@interface LJRulerScrollView : UIScrollView

/** 刻度分界 （几个小刻度为一个大刻度）default is 5 */
@property (nonatomic, assign) NSInteger scaleDividing;

/** 刻度分界线高 default is  (rulerHeight / 2) */
@property (nonatomic, assign) CGFloat scaleDividingLineHeight;

/** 刻度个数 default is 30 */
@property (nonatomic, assign) NSInteger scaleCount;

/** 每个小刻度的值 最小精度 0.1 default is 1 */
@property (nonatomic, assign) CGFloat scaleAverage;

/** 每个小刻度线的高度 default is (rulerHeight - (rulerHeight / 2)) */
@property (nonatomic, assign) CGFloat scaleAverageLineHeight;

/** 刻度间距 default is 5 */
@property (nonatomic, assign) CGFloat scaleSpacing;

/** 刻度当前值 default is 0 */
@property (nonatomic, assign) CGFloat currentValue;

/** 刻度值距离分界线的间距 default is 0 */
@property (nonatomic, assign) CGFloat scaleValueMargin;

/** 刻度值字体 default is [UIFont systemFontOfSize:10] */
@property (nonatomic, strong) UIFont *scaleValueFont;

/** 刻度值颜色 default is blackColor */
@property (nonatomic, strong) UIColor *scaleValueColor;

/** 线宽 default is 1 （包括 基线/分界线/均线） */
@property (nonatomic, assign) CGFloat lineWidth;

/** 刻度分界线颜色（大刻度颜色）default is lightGrayColor */
@property (nonatomic, strong) UIColor *scaleDividingLineColor;

/** 每个小刻度线的颜色 default is grayColor */
@property (nonatomic, strong) UIColor *scaleAverageLineColor;

/** 基线颜色（轴线) default is grayColor */
@property (nonatomic, strong) UIColor *baseLineColor;

@end
