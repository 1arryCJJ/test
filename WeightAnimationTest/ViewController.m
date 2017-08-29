//
//  ViewController.m
//  WeightAnimationTest
//
//  Created by Larry on 2017/6/14.
//  Copyright © 2017年 com.chanxa. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define  KGetWidthPx(x) ceil(x/1080.0*ScreenWidth)

@interface ViewController ()
{
    AnimationView *animationView;
    CGFloat animationCount;  // 当前动画的数值
    CGFloat valueCount;   // 当前动画的最终数值,
    CGFloat lastCount;  // 上次动画之后的数值

}


/**
 动画的速度,不是固定的,根据数据的大小来求速度
 */
@property (nonatomic, assign) CGFloat animationSpeed;

/**
 创建一个定时器(其实是时间较快的话没有也可以,使用系统的处理时间也是可以的,毕竟NSTimer的误差还是挺大的,在此使用主要是省的计数了吧)
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 次数,来计算动画的次数,设置固定的动画次数,来显示动画
 */
@property (nonatomic, assign) NSInteger timeCount;



/**
 显示当前数据的label
 */
@property (nonatomic, strong) UILabel *pregressLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setAnimationView];
    [self setValeLabel];
    
    
}

- (void)setValeLabel
{
    self.pregressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    self.pregressLabel.textColor = [UIColor redColor];
    self.pregressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pregressLabel];
}


/**
 创建动画的
 */
- (void)setAnimationView
{
    
    animationView = [[AnimationView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, KGetWidthPx(1160) - 44)];
    [self.view addSubview:animationView];
    
    
    // 自己创建的按钮,主要是随机生成数值
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
    [btn addTarget:self action:@selector(tapAction) forControlEvents:(UIControlEventTouchUpInside)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"点击随机生成动画" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    
    
}

- (void)tapAction
{
    // 求随机数(0-100的)
    int y = arc4random() % 100;
    
    NSLog(@"生成的随机数是%d",y);
    [self.timer invalidate];
    self.timer = nil;
    _timeCount = 0;
    valueCount = y;
    self.animationSpeed = (valueCount - lastCount) / 200.00000;
    animationCount = lastCount;
    NSLog(@"开始动画,速度是%f",self.animationSpeed);
    CGFloat perTime = 0.007;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:perTime target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}


/**
 定时器方法
 */
- (void)updateTime
{
    animationCount = animationCount + self.animationSpeed;
    self.timeCount++;
    if (self.timeCount > 200) {
        [self.timer invalidate];
        self.timer = nil;
        animationCount = valueCount;
        NSLog(@"结束动画");
    }
    self.pregressLabel.text = [NSString stringWithFormat:@"%f",animationCount];
    lastCount = animationCount;
    [animationView setProgress:animationCount / 100];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
