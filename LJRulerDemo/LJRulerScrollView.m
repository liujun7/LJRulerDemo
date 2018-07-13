//
//  LJRulerScrollView.m
//  LJRulerDemo
//
//  Created by liujun on 2018/7/13.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "LJRulerScrollView.h"

@interface LJRulerScrollView ()

@property (nonatomic, assign) CGFloat rulerHeight;
@property (nonatomic, assign) CGFloat rulerWidth;
@property (nonatomic, strong) CAShapeLayer *dividingScaleLayer;
@property (nonatomic, strong) CAShapeLayer *averageScaleLayer;
@property (nonatomic, strong) CAShapeLayer *baseLineLayer;
@property (nonatomic, strong) NSMutableArray *scaleValueLabels;

@end

@implementation LJRulerScrollView

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    if (self.currentValue > self.scaleCount * self.scaleAverage || self.currentValue < 0) {
        return;
    }
    [self removeObject];
    
    self.rulerWidth = self.bounds.size.width;
    self.rulerHeight = self.bounds.size.height;
    
    CGMutablePathRef dividingScalePathRef = CGPathCreateMutable();
    CGMutablePathRef averageScalePathRef = CGPathCreateMutable();
    CGMutablePathRef baseLinePathRef = CGPathCreateMutable();
    
    CAShapeLayer *dividingScaleLayer = [CAShapeLayer layer];
    dividingScaleLayer.strokeColor = self.scaleAverageLineColor.CGColor;
    dividingScaleLayer.fillColor = [UIColor clearColor].CGColor;
    dividingScaleLayer.lineWidth = self.lineWidth;
    dividingScaleLayer.lineCap = kCALineCapButt;
    self.dividingScaleLayer = dividingScaleLayer;
    
    CAShapeLayer *averageScaleLayer = [CAShapeLayer layer];
    averageScaleLayer.strokeColor = self.scaleAverageLineColor.CGColor;
    averageScaleLayer.fillColor = [UIColor clearColor].CGColor;
    averageScaleLayer.lineWidth = self.lineWidth;
    averageScaleLayer.lineCap = kCALineCapButt;
    self.averageScaleLayer = averageScaleLayer;
    
    CAShapeLayer *baseLineLayer = [CAShapeLayer layer];
    baseLineLayer.strokeColor = self.baseLineColor.CGColor;
    baseLineLayer.fillColor = [UIColor clearColor].CGColor;
    baseLineLayer.lineWidth = self.lineWidth;
    baseLineLayer.lineCap = kCALineCapButt;
    self.baseLineLayer = baseLineLayer;
    
    for (NSInteger i = 0; i <= self.scaleCount; i++) {
        UILabel *scaleValueLabel = [[UILabel alloc] init];
        scaleValueLabel.textColor = self.scaleValueColor;
        scaleValueLabel.font = self.scaleValueFont;
        scaleValueLabel.text = [NSString stringWithFormat:@"%.0f", i * self.scaleAverage];
        CGSize textSize = [scaleValueLabel.text sizeWithAttributes:@{ NSFontAttributeName : scaleValueLabel.font}];
        if (i % self.scaleDividing == 0) {
            CGPathMoveToPoint(dividingScalePathRef, NULL, self.scaleSpacing * i , self.rulerHeight);
            CGPathAddLineToPoint(dividingScalePathRef, NULL, self.scaleSpacing * i, self.scaleDividingLineHeight);
            scaleValueLabel.frame = CGRectMake(self.scaleSpacing * i - textSize.width / 2, self.rulerHeight / 2 - textSize.height - self.scaleValueMargin, 0, 0);
            [scaleValueLabel sizeToFit];
            [self addSubview:scaleValueLabel];
            [self.scaleValueLabels addObject:scaleValueLabel];
        } else {
            CGPathMoveToPoint(averageScalePathRef, NULL, self.scaleSpacing * i , self.rulerHeight);
            CGPathAddLineToPoint(averageScalePathRef, NULL, self.scaleSpacing * i, self.scaleAverageLineHeight);
        }
    }
    
    CGPathMoveToPoint(baseLinePathRef, NULL, -self.scaleCount * self.scaleSpacing, self.rulerHeight);
    CGPathAddLineToPoint(baseLinePathRef, NULL, self.rulerWidth + self.scaleCount * self.scaleSpacing, self.rulerHeight);
    
    dividingScaleLayer.path = dividingScalePathRef;
    averageScaleLayer.path = averageScalePathRef;
    baseLineLayer.path = baseLinePathRef;
    
    [self.layer addSublayer:dividingScaleLayer];
    [self.layer addSublayer:averageScaleLayer];
    [self.layer addSublayer:baseLineLayer];

    [self resetContentOffset];
    self.contentSize = CGSizeMake(self.scaleCount * self.scaleSpacing, self.rulerHeight);
}

- (void)removeObject {
    [self.dividingScaleLayer removeFromSuperlayer];
    [self.averageScaleLayer removeFromSuperlayer];
    [self.baseLineLayer removeFromSuperlayer];
    [self.scaleValueLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.scaleValueLabels removeAllObjects];
}

#pragma mark - 重置contentOffset

- (void)resetContentOffset {
    UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2, 0, self.rulerWidth / 2);
    self.contentInset = edge;
    self.contentOffset = CGPointMake(self.scaleSpacing * (self.currentValue / self.scaleAverage) - self.rulerWidth + (self.rulerWidth / 2), 0);
}

#pragma mark - 懒加载

- (NSMutableArray *)scaleValueLabels {
    if (!_scaleValueLabels) {
        _scaleValueLabels = [[NSMutableArray alloc] init];
    }
    return _scaleValueLabels;
}

#pragma mark - setter方法

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    
    if (self.rulerWidth == 0 || self.rulerHeight == 0) {
        [self setNeedsDisplay];
    } else {
        [self resetContentOffset];
    }
}

- (void)setScaleDividing:(NSInteger)scaleDividing {
    _scaleDividing = scaleDividing;
    
    [self setNeedsDisplay];
}

- (void)setScaleDividingLineHeight:(CGFloat)scaleDividingLineHeight {
    _scaleDividingLineHeight = scaleDividingLineHeight;
    
    [self setNeedsDisplay];
}

- (void)setScaleCount:(NSInteger)scaleCount {
    _scaleCount = scaleCount;
    
    [self setNeedsDisplay];
}

- (void)setScaleAverage:(CGFloat)scaleAverage {
    _scaleAverage = scaleAverage;
    
    [self setNeedsDisplay];
}

- (void)setScaleAverageLineHeight:(CGFloat)scaleAverageLineHeight {
    _scaleAverageLineHeight = scaleAverageLineHeight;
    
    [self setNeedsDisplay];
}

- (void)setScaleSpacing:(CGFloat)scaleSpacing {
    _scaleSpacing = scaleSpacing;
    
    [self setNeedsDisplay];
}

- (void)setScaleValueMargin:(CGFloat)scaleValueMargin {
    _scaleValueMargin = scaleValueMargin;
    
    [self setNeedsDisplay];
}

- (void)setScaleValueFont:(UIFont *)scaleValueFont {
    _scaleValueFont = scaleValueFont;
    
    [self setNeedsDisplay];
}

- (void)setScaleValueColor:(UIColor *)scaleValueColor {
    _scaleValueColor = scaleValueColor;
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

- (void)setScaleDividingLineColor:(UIColor *)scaleDividingLineColor {
    _scaleDividingLineColor = scaleDividingLineColor;
    
    [self setNeedsDisplay];
}

- (void)setScaleAverageLineColor:(UIColor *)scaleAverageLineColor {
    _scaleAverageLineColor = scaleAverageLineColor;
    
    [self setNeedsDisplay];
}

- (void)setBaseLineColor:(UIColor *)baseLineColor {
    _baseLineColor = baseLineColor;
    
    [self setNeedsDisplay];
}

@end
