//
//  AnimationView.m
//  WeightAnimationTest
//
//  Created by Larry on 2017/6/14.
//  Copyright © 2017年 com.chanxa. All rights reserved.
//

#import "AnimationView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define  KGetWidthPx(x) ceil(x/1080.0*ScreenWidth)


//环形开始的位置
#define CircleStart  M_PI * 3/4
//环形结束的位置
#define CircleEnd    M_PI * 1/4

#define BackGroundColor  [UIColor lightGrayColor] //环形背景默认颜色

#define ProgressColor [UIColor greenColor] //进度的颜色

//环形的宽度
#define circleWidth 10


@interface AnimationView ()
{
    CAShapeLayer *animationCircleLayer; // 动画的环形圆圈
    CAShapeLayer *bgCircleLayer; // 背景的环形圆圈
    CGFloat radius; // 环形的进度半径
    CGPoint circleCenter; // 中心店
    double progress; // 当前的动画的进度比例
    CGFloat radian; // 进度
 }


@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
        [self initBGCircle];
     }
    return self;
}

//设置
- (void)configuration
{
    // 半径设置
     radius = KGetWidthPx(740) * 0.5 ;
    // 中心点
    circleCenter = CGPointMake(ScreenWidth / 2, ScreenWidth / 2);
}

/**
 创建背景的环形圆圈
 */
- (void)initBGCircle
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:circleCenter radius:radius startAngle:CircleStart endAngle:CircleEnd clockwise:YES];
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    bgCircleLayer = [CAShapeLayer layer];
    bgCircleLayer.lineJoin = kCALineJoinRound;
    bgCircleLayer.lineCap = kCALineCapRound;
    bgCircleLayer.path = path.CGPath;
    bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
    bgCircleLayer.strokeColor = BackGroundColor.CGColor;
    bgCircleLayer.lineWidth = circleWidth;
    [self.layer addSublayer:bgCircleLayer];
    
}

// 根据传过来的数值来显示当前的动画进度
- (void)setProgress:(double)value {
    
    if (value > 1) {
        value = 1;
    }
    radian = value * (2* M_PI - fabs(CircleStart - CircleEnd));
     //圆环
    
     [self creatCircleLayer];
}

//进度圆环
- (void)creatCircleLayer
{
    
    if (animationCircleLayer != nil) {
        
          animationCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:CircleStart endAngle:CircleStart + radian clockwise:YES].CGPath;
 

    } else {
        
        UIBezierPath *path  = [UIBezierPath bezierPath];
        [path addArcWithCenter:circleCenter radius:radius startAngle:CircleStart endAngle:CircleStart + radian clockwise:YES];
        animationCircleLayer = [CAShapeLayer layer];
        animationCircleLayer.path = path.CGPath;
        animationCircleLayer.fillColor = [UIColor clearColor].CGColor;
        animationCircleLayer.strokeColor = ProgressColor.CGColor;
        path.lineJoinStyle = kCGLineCapRound;  //终点处理
        path.lineCapStyle = kCGLineCapRound;
        animationCircleLayer.lineJoin = kCALineJoinRound;
        animationCircleLayer.lineCap = kCALineCapRound;
        animationCircleLayer.lineWidth = circleWidth;
        [self.layer addSublayer:animationCircleLayer];
        
 
    }

}


#pragma mark ----animations

// 这是系统的动画,当初准备用这个,但是发现不能减少操作,不知道哪位大神知道怎么用呢
- (void)circleAnimation:(CALayer*)layer
{
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = 2;
    basic.fromValue = @(0);
    basic.toValue = @(1);
    [layer addAnimation:basic forKey:@"StrokeEndKey"];
}






@end
