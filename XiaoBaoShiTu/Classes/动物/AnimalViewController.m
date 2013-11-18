//
//  DongWuViewController.m
//  XiaoBaoShiTu
//
//  Created by longanxiang_iMac on 13-8-24.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import "AnimalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>
@interface AnimalController ()
{
    UIView* contentView;
    UIImageView* contentImage;
    CATransition* animation;
    
    NSString* imageName;
    NSString* button_ch_text;
    NSString* button_eng_text;
    
    NSString* button_ch_audio;
    NSString* button_eng_audio;
    AVAudioPlayer* avAudioPlayer;
    
    NSString* bgMusicName;
    AVAudioPlayer* bgAudioPlayer;
}

@end
extern NSString *strZhi;
@implementation AnimalController

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
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"animalBg.png"]];
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

//-(void)loadBgMusic
//{
//    bgMusicName = @"02 La nuit";
//    NSError* err;
//    NSString* string = [[NSBundle mainBundle]pathForResource:@"02 La nuit" ofType:@"m4a"];
//    musicPlayer = [[[AVAudioPlayer alloc] init]autorelease];
//    [musicPlayer initWithContentsOfURL:[NSURL fileURLWithPath:string] error:&err];
//    [musicPlayer play];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"strZhi=%@",strZhi);
    //多线程音乐
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSError * err = nil;
                       NSString * path = [[NSBundle mainBundle]pathForResource:@"04 Le monde de contre jour" ofType:@"m4a"];
                       NSURL * url = [NSURL fileURLWithPath:path];
                       
                       bgAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
                       if (nil == bgAudioPlayer) {
                           NSLog(@"Error: %@", [err localizedDescription]);
                       }
                       [bgAudioPlayer prepareToPlay];
                       bgAudioPlayer.numberOfLoops = -1;
                       bgAudioPlayer.volume = 1.0;
                       [bgAudioPlayer play];
                   });
    
    // Create back button
    UIButton * back_btn = [self creatButtonWithFrame:CGRectMake(15, 40, 120, 63) tag:22 text:@"" font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:back_btn];
    [back_btn setBackgroundImage:[UIImage imageNamed:@"leafBtn02.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_btn release];
    
    [self createView];
    [self createImageView];
    
    
    [self createDownAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];

    
    [self createGesture];

    //butterFly
    [self loadButterFly];
    
}

#pragma mark - create image
-(void)createDownAnimation
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

- (void)addAnimations
{
    //让图片来回移动
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 240)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 300)];
    //    translation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.1415, 0, 0, 1.0)];//翻转效果
    //    translation.toValue = [NSNumber numberWithDouble:1.5];//缩放效果
    translation.duration = 2;//动画持续时间
    translation.repeatCount = HUGE_VALF;//动画重复次数
    translation.autoreverses = NO;//是否自动重复
    
    //让图片来回转动
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //kCAMediaTimingFunctionLinear 表示时间方法为线性，使得足球匀速转动
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.toValue = [NSNumber numberWithFloat:4 * M_PI];
    rotation.duration = 2;
    rotation.repeatCount = HUGE_VALF;
    rotation.autoreverses = NO;
    
    [contentImage.layer addAnimation:rotation forKey:@"rotation"];
    [contentImage.layer addAnimation:translation forKey:@"translation"];
}

-(void)createView
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(150, 150, 480, 480)];
    [contentView setBackgroundColor:[UIColor clearColor]];
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
int mark1 = 0;
static int identifer = 0;
- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if (mark1 == 2) {
        identifer++;
    }
    switch (identifer) {
        case 0:
            [self setImageName:@"Bear.png" andChineseText:@"熊" andEnglishText:@"Bear"];
            break;
        case 1:
            [self setImageName:@"Crab.png" andChineseText:@"螃蟹" andEnglishText:@"Crab"];
            break;
        case 2:
            [self setImageName:@"crocodile.png" andChineseText:@"鳄鱼" andEnglishText:@"Crocodile"];
            break;
        case 3:
            [self setImageName:@"Dog.png" andChineseText:@"狗" andEnglishText:@"Dog"];
            break;
        case 4:
            [self setImageName:@"Duck.png" andChineseText:@"鸭子" andEnglishText:@"Duck"];
            break;
        case 5:
            [self setImageName:@"Elephant.png" andChineseText:@"大象" andEnglishText:@"Elephant"];
            break;
        case 6:
            [self setImageName:@"Fox.png" andChineseText:@"狐狸" andEnglishText:@"Fox"];
            break;
        case 7:
            [self setImageName:@"Lion.png" andChineseText:@"狮子" andEnglishText:@"Lion"];
            break;
        case 8:
            [self setImageName:@"Lizard.png" andChineseText:@"蜥蜴" andEnglishText:@"Lizard"];
            break;
        case 9:
            [self setImageName:@"Orangutan.png" andChineseText:@"猩猩" andEnglishText:@"Orangutan"];
            break;
        case 10:
            [self setImageName:@"Panda.png" andChineseText:@"熊猫" andEnglishText:@"Panda"];
            break;
        case 11:
            [self setImageName:@"Parrot.png" andChineseText:@"鹦鹉" andEnglishText:@"Parrot"];
            break;
        case 12:
            [self setImageName:@"Penguin.png" andChineseText:@"企鹅" andEnglishText:@"Penguin"];
            break;
        case 13:
            [self setImageName:@"Rabbit.png" andChineseText:@"兔子" andEnglishText:@"Rabbit"];
            break;
        case 14:
            [self setImageName:@"Sheep.png" andChineseText:@"羊" andEnglishText:@"Sheep"];
            break;
        case 15:
            [self setImageName:@"Snail.png" andChineseText:@"蜗牛" andEnglishText:@"Snail"];
            break;
        case 16:
            [self setImageName:@"Snake.png" andChineseText:@"蛇" andEnglishText:@"Snake"];
            break;
        case 17:
            [self setImageName:@"Squirrel.png" andChineseText:@"松鼠" andEnglishText:@"Squirrel"];
            break;
        case 18:
            [self setImageName:@"Tiger.png" andChineseText:@"老虎" andEnglishText:@"Tiger"];
            break;
        case 19:
            [self setImageName:@"Zebra.png" andChineseText:@"斑马" andEnglishText:@"Zebra"];
            break;
        default:
            [self setImageName:@"Bear.png" andChineseText:@"熊" andEnglishText:@"Bear"];
            identifer = 0;
            break;
    }
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createDownAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    //create two button
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(600, 50, 250, 132) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:50] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn_ch];
    [btn_ch setBackgroundImage:[UIImage imageNamed:@"cloudBtn.png"] forState:UIControlStateNormal];
    [btn_ch release];
    
    
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(700, 200, 250, 132) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:45] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn_eng];
    [btn_eng addTarget:self action:@selector(playAnimalEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [btn_eng setBackgroundImage:[UIImage imageNamed:@"cloudBtn.png"] forState:UIControlStateNormal];
    [btn_eng release];
     
    identifer++;
    mark1 = 1;
}

-(void)oneFingerSwipeUp:(UISwipeGestureRecognizer*)recognizer
{
    
    if (mark1 == 1) {
        identifer--;
        identifer--;    
    }
    else {
        identifer--;
    }
    
    switch (identifer) {
        case 0:
            [self setImageName:@"Bear.png" andChineseText:@"熊" andEnglishText:@"Bear"];
            break;
        case 1:
            [self setImageName:@"Crab.png" andChineseText:@"螃蟹" andEnglishText:@"Crab"];
            break;
        case 2:
            [self setImageName:@"crocodile.png" andChineseText:@"鳄鱼" andEnglishText:@"Crocodile"];
            break;
        case 3:
            [self setImageName:@"Dog.png" andChineseText:@"狗" andEnglishText:@"Dog"];
            break;
        case 4:
            [self setImageName:@"Duck.png" andChineseText:@"鸭子" andEnglishText:@"Duck"];
            break;
        case 5:
            [self setImageName:@"Elephant.png" andChineseText:@"大象" andEnglishText:@"Elephant"];
            break;
        case 6:
            [self setImageName:@"Fox.png" andChineseText:@"狐狸" andEnglishText:@"Fox"];
            break;
        case 7:
            [self setImageName:@"Lion.png" andChineseText:@"狮子" andEnglishText:@"Lion"];
            break;
        case 8:
            [self setImageName:@"Lizard.png" andChineseText:@"蜥蜴" andEnglishText:@"Lizard"];
            break;
        case 9:
            [self setImageName:@"Orangutan.png" andChineseText:@"猩猩" andEnglishText:@"Orangutan"];
            break;
        case 10:
            [self setImageName:@"Panda.png" andChineseText:@"熊猫" andEnglishText:@"Panda"];
            break;
        case 11:
            [self setImageName:@"Parrot.png" andChineseText:@"鹦鹉" andEnglishText:@"Parrot"];
            break;
        case 12:
            [self setImageName:@"Penguin.png" andChineseText:@"企鹅" andEnglishText:@"Penguin"];
            break;
        case 13:
            [self setImageName:@"Rabbit.png" andChineseText:@"兔子" andEnglishText:@"Rabbit"];
            break;
        case 14:
            [self setImageName:@"Sheep.png" andChineseText:@"羊" andEnglishText:@"Sheep"];
            break;
        case 15:
            [self setImageName:@"Snail.png" andChineseText:@"蜗牛" andEnglishText:@"Snail"];
            break;
        case 16:
            [self setImageName:@"Snake.png" andChineseText:@"蛇" andEnglishText:@"Snake"];
            break;
        case 17:
            [self setImageName:@"Squirrel.png" andChineseText:@"松鼠" andEnglishText:@"Squirrel"];
            break;
        case 18:
            [self setImageName:@"Tiger.png" andChineseText:@"老虎" andEnglishText:@"Tiger"];
            break;
        case 19:
            [self setImageName:@"Zebra.png" andChineseText:@"斑马" andEnglishText:@"Zebra"];
            break;
        default:
            [self setImageName:@"Zebra.png" andChineseText:@"斑马" andEnglishText:@"Zebra"];
            identifer = 19;
            break;
    }
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createUpAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
        
    //create two button
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(600, 50, 250, 132) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:50] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn_ch];
    [btn_ch setBackgroundImage:[UIImage imageNamed:@"cloudBtn.png"] forState:UIControlStateNormal];
    [btn_ch release];
            
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(700, 200, 250, 132) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:45] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn_eng];
    [btn_eng addTarget:self action:@selector(playAnimalEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [btn_eng setBackgroundImage:[UIImage imageNamed:@"cloudBtn.png"] forState:UIControlStateNormal];
    [btn_eng release];
    
    mark1 = 2;        
}

-(void)setImageName:(NSString*)iName andChineseText:(NSString*)chText andEnglishText:(NSString*)enText
{
    imageName = iName;
    button_ch_text = chText;
    button_eng_text = enText;
}

#pragma mark - create button

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

#pragma mark - play audio

-(void)playAnimalEngAudio:(UIButton *)button
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

#pragma mark - butterFly

-(void)loadButterFly
{
    NSMutableArray *bflies = [NSMutableArray array];
	for (int i = 1; i <= 17; i++)
		[bflies addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"bf_%d", i] ofType:@"png"]]];
	
	UIImageView *butterflyView = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 300.0f, 60.0f, 60.0f)];
	butterflyView.tag = 300;
	butterflyView.animationImages = bflies;
	butterflyView.animationDuration = 0.75f;
	[self.view addSubview:butterflyView];
	[butterflyView startAnimating];
	[butterflyView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
