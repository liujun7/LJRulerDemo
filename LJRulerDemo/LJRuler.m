//
//  LJRuler.m
//  LJRulerDemo
//
//  Created by liujun on 2018/7/13.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "LJRuler.h"

@interface LJRuler () <UIScrollViewDelegate>

@property (nonatomic, strong) LJRulerScrollView *rulerScrollView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *indicatorLineLayer;

@end

@implementation LJRuler

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefuatlParameter];
        [self addSubview:self.rulerScrollView];
    }
    return self;
}

- (void)setDefuatlParameter {
    self.currentValue = 0;
    self.indicatorColor = [UIColor redColor];
    self.scaleDividing = 5;
    self.scaleCount = 30;
    self.scaleAverage = 1;
    self.scaleSpacing = 5;
    self.scaleValueFont = [UIFont systemFontOfSize:10];
    self.scaleValueColor = [UIColor blackColor];
    self.lineWidth = 1;
    self.scaleDividingLineColor = [UIColor lightGrayColor];
    self.scaleAverageLineColor = [UIColor grayColor];
    self.baseLineColor = [UIColor grayColor];
    self.rulerScrollView.backgroundColor = [UIColor whiteColor];
    self.indicatorLineWidth = 1;
    self.indicatorLineHeight = 0;
    self.scaleValueMargin = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.rulerScrollView.frame = self.bounds;
    self.scaleDividingLineHeight = 0.5 * self.bounds.size.height;
    self.scaleAverageLineHeight = self.bounds.size.height - (self.bounds.size.height / 4);
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    [self.gradientLayer removeFromSuperlayer];
    [self.indicatorLineLayer removeFromSuperlayer];

    [self drawGradientLayerAndIndicator];
}

#pragma mark - 绘制渐变图层和指示器

- (void)drawGradientLayerAndIndicator {
    
    // 渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor];
    gradientLayer.locations = @[[NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.6]];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    // 指示器
    CAShapeLayer *indicatorLineLayer = [CAShapeLayer layer];
    indicatorLineLayer.strokeColor = self.indicatorColor.CGColor;
    indicatorLineLayer.fillColor = self.indicatorColor.CGColor;
    indicatorLineLayer.lineWidth = self.indicatorLineWidth;
    indicatorLineLayer.lineCap = kCALineCapSquare;
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - self.lineWidth);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, self.indicatorLineHeight);
    indicatorLineLayer.path = pathLine;
    [self.layer addSublayer:indicatorLineLayer];
    self.indicatorLineLayer = indicatorLineLayer;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(LJRulerScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2;
    CGFloat currentValue = (offSetX / scrollView.scaleSpacing) * scrollView.scaleAverage;
    if (currentValue < 0.f) {
        return;
    } else if (currentValue > scrollView.scaleCount * scrollView.scaleAverage) {
        return;
    }
    scrollView.currentValue = currentValue;
    [self.delegate ruler:self didScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(LJRulerScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(LJRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
}

- (void)animationRebound:(LJRulerScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2;
    CGFloat oX = (offSetX / scrollView.scaleSpacing) * scrollView.scaleAverage;
    if ([self isIntegerValue:@(scrollView.scaleAverage)]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
    CGFloat offX = (oX / (scrollView.scaleAverage)) * scrollView.scaleSpacing - self.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

#pragma mark - 精度处理方法

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)isIntegerValue:(NSNumber *)value {
    NSString *text = [NSString stringWithFormat:@"%f",[value floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[text componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *tempText = nil;
        for(NSInteger i =0; i < [valueEnd length]; i++) {
            tempText = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![tempText isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 懒加载

- (LJRulerScrollView *)rulerScrollView {
    if (!_rulerScrollView) {
        _rulerScrollView = [LJRulerScrollView new];
        _rulerScrollView.delegate = self;
        _rulerScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _rulerScrollView;
}

#pragma mark - setter方法

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    
    self.rulerScrollView.currentValue = currentValue;
}

- (void)setScaleDividing:(NSInteger)scaleDividing {
    _scaleDividing = scaleDividing;
    
    self.rulerScrollView.scaleDividing = scaleDividing;
}

- (void)setScaleDividingLineHeight:(CGFloat)scaleDividingLineHeight {
    _scaleDividingLineHeight = scaleDividingLineHeight;
    
    self.rulerScrollView.scaleDividingLineHeight = scaleDividingLineHeight;
}

- (void)setScaleCount:(NSInteger)scaleCount {
    _scaleCount = scaleCount;
    
    self.rulerScrollView.scaleCount = scaleCount;
}

- (void)setScaleAverage:(CGFloat)scaleAverage {
    _scaleAverage = scaleAverage;
    
    self.rulerScrollView.scaleAverage = scaleAverage;
}

- (void)setScaleAverageLineHeight:(CGFloat)scaleAverageLineHeight {
    _scaleAverageLineHeight = scaleAverageLineHeight;
    
    self.rulerScrollView.scaleAverageLineHeight = scaleAverageLineHeight;
}

- (void)setScaleSpacing:(CGFloat)scaleSpacing {
    _scaleSpacing = scaleSpacing;
    
    self.rulerScrollView.scaleSpacing = scaleSpacing;
}

- (void)setScaleValueMargin:(CGFloat)scaleValueMargin {
    _scaleValueMargin = scaleValueMargin;
    
    self.rulerScrollView.scaleValueMargin = scaleValueMargin;
}

- (void)setScaleValueFont:(UIFont *)scaleValueFont {
    _scaleValueFont = scaleValueFont;
    
    self.rulerScrollView.scaleValueFont = scaleValueFont;
}

- (void)setScaleValueColor:(UIColor *)scaleValueColor {
    _scaleValueColor = scaleValueColor;
    
    self.rulerScrollView.scaleValueColor = scaleValueColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.rulerScrollView.lineWidth = lineWidth;
}

- (void)setScaleDividingLineColor:(UIColor *)scaleDividingLineColor {
    _scaleDividingLineColor = scaleDividingLineColor;
    
    self.rulerScrollView.scaleDividingLineColor = scaleDividingLineColor;
}

- (void)setScaleAverageLineColor:(UIColor *)scaleAverageLineColor {
    _scaleAverageLineColor = scaleAverageLineColor;
    
    self.rulerScrollView.scaleAverageLineColor = scaleAverageLineColor;
}

- (void)setBaseLineColor:(UIColor *)baseLineColor {
    _baseLineColor = baseLineColor;
    
    self.rulerScrollView.baseLineColor = baseLineColor;
}

- (void)setRulerColor:(UIColor *)rulerColor {
    _rulerColor = rulerColor;
    
    self.rulerScrollView.backgroundColor = rulerColor;
}

- (void)setIndicatorLineWidth:(CGFloat)indicatorLineWidth {
    _indicatorLineWidth = indicatorLineWidth;
    
    [self setNeedsDisplay];
}

- (void)setIndicatorLineHeight:(CGFloat)indicatorLineHeight {
    _indicatorLineHeight = indicatorLineHeight;
    
    [self setNeedsDisplay];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    [self setNeedsDisplay];
}

@end
