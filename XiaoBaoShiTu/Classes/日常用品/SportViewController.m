//
//  RCYPViewController.m
//  XiaoBaoShiTu
//
//  Created by longanxiang_iMac on 13-8-24.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import "SportViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>

@interface SportViewController ()
{
    UIView* contentView;
    UIImageView* contentImage;
    CATransition* animation;
    CABasicAnimation* rotateAnimation;
    
    NSString* imageName;
    NSString* button_ch_text;
    NSString* button_eng_text;
    
    NSString* button_ch_audio;
    NSString* button_eng_audio;
    AVAudioPlayer* avAudioPlayer;
    AVAudioPlayer * bgAudioPlayer;
}

@end

@implementation SportViewController
extern NSString *strZhi;
- (void)dealloc
{
    [contentView release];
    [contentImage release];
    [avAudioPlayer release];
    [bgAudioPlayer release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"animalBg2.png"]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"strZhi=%@",strZhi);
    //多线程音乐
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError * err = nil;
                       NSString * path = [[NSBundle mainBundle]pathForResource:@"06 Songeries d'un orchestre" ofType:@"m4a"];
                       NSURL * url = [NSURL fileURLWithPath:path];
                       
                       bgAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
                       if (nil == bgAudioPlayer) {
                           NSLog(@"Error: %@", [err localizedDescription]);
                       }
                       [bgAudioPlayer prepareToPlay];
                       bgAudioPlayer.numberOfLoops = -1;
                       bgAudioPlayer.volume = 0.2;
                       [bgAudioPlayer play];
                   });
    
    //create back btn
    UIButton * back_btn = [self creatButtonWithFrame:CGRectMake(15, 40, 120, 63) tag:22 text:@"" font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:back_btn];
    [back_btn setBackgroundImage:[UIImage imageNamed:@"leafBtn02.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_btn release];
    
    [self createView];
    [self createImageView];
    
    [self createAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    [self createGesture];
    
        
}

#pragma mark - create image
-(void)createAnimation
{
    animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromBottom;
}

-(void)createUpAnimation
{
    animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
}

-(void)addRotateAnimation
{
    //让图片来回转动
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //kCAMediaTimingFunctionLinear 表示时间方法为线性，使得足球匀速转动
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.toValue = [NSNumber numberWithFloat:4 * M_PI];
    rotation.duration = 2;
    rotation.repeatCount = 1;
    rotation.autoreverses = NO;
    [contentImage.layer addAnimation:rotation forKey:@"rotation"];
}

-(void)createView
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(150, 150, 480, 480)];
    [contentView setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.1]];
    [self.view addSubview:contentView];
}

-(void)createImageView
{
    contentImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [contentView addSubview:contentImage];
}

#pragma mark - gesture & switch
-(void)createGesture
{
    UISwipeGestureRecognizer *oneFingerSwipeDown =  [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)] autorelease];
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [contentView addGestureRecognizer:oneFingerSwipeDown];
    
    UISwipeGestureRecognizer *oneFingerSwipeUp =  [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)] autorelease];
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [contentView addGestureRecognizer:oneFingerSwipeUp];
}

int mark3 = 0;
static int identifer = 0;
- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if (mark3 == 2) {
        identifer++;
    }
   switch (identifer) {
        case 0:
            [self setImageName:@"Badminton.png" andChineseText:@"羽毛球" andEnglishText:@"Badminton"];
            break;
        case 1:
           [self setImageName:@"Baseball.png" andChineseText:@"棒球" andEnglishText:@"Baseball"];
           [self addRotateAnimation];
            break;
        case 2:
            [self setImageName:@"Basketball.png" andChineseText:@"篮球" andEnglishText:@"Basketball"];
           [self addRotateAnimation];
           break;
        case 3:
           [self setImageName:@"Bicycle.png" andChineseText:@"自行车" andEnglishText:@"Bicycle"];
             break;
        case 4:
            [self setImageName:@"Billiards.png" andChineseText:@"台球" andEnglishText:@"Billiards"];
            break;
        case 5:
            [self setImageName:@"Bowling.png" andChineseText:@"保龄球" andEnglishText:@"Bowling"];
            break;
        case 6:
            [self setImageName:@"Dumbbell.png" andChineseText:@"哑铃" andEnglishText:@"Dumbbell"];
            break;
        case 7:
            [self setImageName:@"Football.png" andChineseText:@"足球" andEnglishText:@"Football"];
           [self addRotateAnimation];
            break;
        case 8:
            [self setImageName:@"Golf.png" andChineseText:@"高尔夫" andEnglishText:@"Golf"];
            break;
        case 9:
            [self setImageName:@"International Chess.png" andChineseText:@"国际象棋" andEnglishText:@"International Chess"];
            break;
        case 10:
            [self setImageName:@"Ping-pong.png" andChineseText:@"乒乓球" andEnglishText:@"Ping-pong"];
            break;
        case 11:
           [self setImageName:@"Poker.png" andChineseText:@"扑克" andEnglishText:@"Poker"];
           break;
        case 12:
           [self setImageName:@"Roller Skate.png" andChineseText:@"轮滑鞋" andEnglishText:@"Roller Skate"];
           break;
        case 13:
           [self setImageName:@"Rugby.png" andChineseText:@"橄榄球" andEnglishText:@"Rugby"];
           break;
        case 14:
            [self setImageName:@"Skateboard.png" andChineseText:@"滑板" andEnglishText:@"Skateboard"];
            break;
        case 15:
            [self setImageName:@"Skip.png" andChineseText:@"跳绳" andEnglishText:@"Skip"];
            break;
       case 16:
           [self setImageName:@"Sports Shoes.png" andChineseText:@"运动鞋" andEnglishText:@"Sports Shoes"];
           break;
        case 17:
           [self setImageName:@"Stopwatch.png" andChineseText:@"秒表" andEnglishText:@"Stopwatch"];
            break;
        case 18:
            [self setImageName:@"Tennis.png" andChineseText:@"网球" andEnglishText:@"Tennis"];
           [self addRotateAnimation];
            break;
        case 19:
            [self setImageName:@"Volleyball.png" andChineseText:@"排球" andEnglishText:@"Volleyball"];
           [self addRotateAnimation];
            break;
        default:
           identifer = 0;
            [self setImageName:@"badminton.png" andChineseText:@"羽毛球" andEnglishText:@"Badminton"];
            break;
    }
    
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    //create two button
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(650, 100, 300, 100) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_ch addTarget:self action:@selector(playSportChAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_ch];
    [btn_ch release];
    
    
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(650, 300, 320, 100) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:35] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_eng addTarget:self action:@selector(playSportEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_eng];
    [btn_eng release];
    
    identifer++;
    mark3 = 1;
    
}

- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    if (mark3 == 1) {
        identifer--;
        identifer--;
    }
    else {
        identifer--;
    }

    switch (identifer) {
        case 0:
            [self setImageName:@"Badminton.png" andChineseText:@"羽毛球" andEnglishText:@"Badminton"];
            break;
        case 1:
            [self setImageName:@"Baseball.png" andChineseText:@"棒球" andEnglishText:@"Baseball"];
            [self addRotateAnimation];
            break;
        case 2:
            [self setImageName:@"Basketball.png" andChineseText:@"篮球" andEnglishText:@"Basketball"];
            [self addRotateAnimation];
            break;
        case 3:
            [self setImageName:@"Bicycle.png" andChineseText:@"自行车" andEnglishText:@"Bicycle"];
            break;
        case 4:
            [self setImageName:@"Billiards.png" andChineseText:@"台球" andEnglishText:@"Billiards"];
            break;
        case 5:
            [self setImageName:@"Bowling.png" andChineseText:@"保龄球" andEnglishText:@"Bowling"];
            break;
        case 6:
            [self setImageName:@"Dumbbell.png" andChineseText:@"哑铃" andEnglishText:@"Dumbbell"];
            break;
        case 7:
            [self setImageName:@"Football.png" andChineseText:@"足球" andEnglishText:@"Football"];
            [self addRotateAnimation];
            break;
        case 8:
            [self setImageName:@"Golf.png" andChineseText:@"高尔夫" andEnglishText:@"Golf"];
            break;
        case 9:
            [self setImageName:@"International Chess.png" andChineseText:@"国际象棋" andEnglishText:@"International Chess"];
            break;
        case 10:
            [self setImageName:@"Ping-pong.png" andChineseText:@"乒乓球" andEnglishText:@"Ping-pong"];
            break;
        case 11:
            [self setImageName:@"Poker.png" andChineseText:@"扑克" andEnglishText:@"Poker"];
            break;
        case 12:
            [self setImageName:@"Roller Skate.png" andChineseText:@"轮滑鞋" andEnglishText:@"Roller Skate"];
            break;
        case 13:
            [self setImageName:@"Rugby.png" andChineseText:@"橄榄球" andEnglishText:@"Rugby"];
            break;
        case 14:
            [self setImageName:@"Skateboard.png" andChineseText:@"滑板" andEnglishText:@"Skateboard"];
            break;
        case 15:
            [self setImageName:@"Skip.png" andChineseText:@"跳绳" andEnglishText:@"Skip"];
            break;
        case 16:
            [self setImageName:@"Sports Shoes.png" andChineseText:@"运动鞋" andEnglishText:@"Sports Shoes"];
            break;
        case 17:
            [self setImageName:@"Stopwatch.png" andChineseText:@"秒表" andEnglishText:@"Stopwatch"];
            break;
        case 18:
            [self setImageName:@"Tennis.png" andChineseText:@"网球" andEnglishText:@"Tennis"];
            [self addRotateAnimation];
            break;
        case 19:
            [self setImageName:@"Volleyball.png" andChineseText:@"排球" andEnglishText:@"Volleyball"];
            [self addRotateAnimation];
            break;
        default:
            identifer = 19;
            [self setImageName:@"Volleyball.png" andChineseText:@"排球" andEnglishText:@"Volleyball"];
            break;
    }
    
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createUpAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    //create two button
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(650, 100, 300, 100) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_ch addTarget:self action:@selector(playSportChAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_ch];
    [btn_ch release];
    
    
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(650, 300, 320, 100) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:35] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_eng addTarget:self action:@selector(playSportEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_eng];
    [btn_eng release];
    
    mark3 = 2;
    
}

-(void)setImageName:(NSString*)iName andChineseText:(NSString*)chText andEnglishText:(NSString*)enText
{
    imageName = iName;
    button_ch_text = chText;
    button_eng_text = enText;
}

#pragma mark - create button

//the same as the method in rootviewcontroller.m
- (UIButton *)creatButtonWithFrame:(CGRect)frame tag:(NSInteger)tag text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    button.titleLabel.font = font;
    button.backgroundColor = bgColor;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

#pragma mark - audio player
-(void)playSportChAudio:(UIButton *)button
{
    button_ch_audio = button.titleLabel.text;
    NSError* err;
    NSString* string = [[NSBundle mainBundle]pathForResource:button_ch_audio ofType:@"wav"];
    NSLog(@"%@",string);

    if(!avAudioPlayer){
        avAudioPlayer = [[AVAudioPlayer alloc] init];
    }
    [avAudioPlayer initWithContentsOfURL:[NSURL fileURLWithPath:string] error:&err];
    [avAudioPlayer play];
    NSLog(@"error is : %@",[err localizedDescription]);
}

-(void)playSportEngAudio:(UIButton*)button
{
    button_eng_audio = button.titleLabel.text;
    NSError* err;
    NSString* string = [[NSBundle mainBundle]pathForResource:button_eng_audio ofType:@"mp3"];
    if(!avAudioPlayer){
        avAudioPlayer = [[AVAudioPlayer alloc] init];
    }
    [avAudioPlayer initWithContentsOfURL:[NSURL fileURLWithPath:string] error:&err];
    [avAudioPlayer play];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
