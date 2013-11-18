//
//  ShuiGuoViewController.m
//  XiaoBaoShiTu
//
//  Created by longanxiang_iMac on 13-8-24.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import "FruitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>
@interface FruitViewController ()
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
    AVAudioPlayer* bgAudioPlayer;
}
@end
extern NSString *strZhi;
@implementation FruitViewController

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
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fruitBackground.png"]];
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
                       NSString * path = [[NSBundle mainBundle]pathForResource:@"05 Le mystère de contre jour" ofType:@"m4a"];
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

-(void)createView
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(150, 200, 480, 480)];
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

int mark2 = 0;
static int identifer = 0;
- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if (mark2 == 2) {
        identifer++;
    }
    switch (identifer) {
        case 0:
            [self setImageName:@"Apple.png" andChineseText:@"苹果" andEnglishText:@"Apple"];
            break;
        case 1:
            [self setImageName:@"Apricot.png" andChineseText:@"杏" andEnglishText:@"Apricot"];
            break;
        case 2:
            [self setImageName:@"Banana.png" andChineseText:@"香蕉" andEnglishText:@"Banana"];
            break;
        case 3:
            [self setImageName:@"Cherry.png" andChineseText:@"樱桃" andEnglishText:@"Cherry"];
            break;
        case 4:
            [self setImageName:@"Coconut.png" andChineseText:@"椰子" andEnglishText:@"Coconut"];
            break;
        case 5:
            [self setImageName:@"Durian.png" andChineseText:@"榴莲" andEnglishText:@"Durian"];
            break;
        case 6:
            [self setImageName:@"Fig.png" andChineseText:@"无花果" andEnglishText:@"Fig"];
            break;
        case 7:
            [self setImageName:@"Kiwifruit.png" andChineseText:@"猕猴桃" andEnglishText:@"Kiwifruit"];
            break;
        case 8:
            //mark
            [self setImageName:@"Lemon.png" andChineseText:@"柠檬" andEnglishText:@"Lemon"];
            break;
        case 9:
            [self setImageName:@"Loquat.png" andChineseText:@"枇杷" andEnglishText:@"Loquat"];
            break;
        case 10:
            [self setImageName:@"Mango.png" andChineseText:@"芒果" andEnglishText:@"Mango"];
            break;
        case 11:
            [self setImageName:@"Mangosteen.png" andChineseText:@"山竹" andEnglishText:@"Mangosteen"];
            break;
        case 12:
            [self setImageName:@"Muskmelon.png" andChineseText:@"香瓜" andEnglishText:@"Muskmelon"];
            break;
        case 13:
            [self setImageName:@"Pawpaw.png" andChineseText:@"木瓜" andEnglishText:@"Pawpaw"];
            break;
        case 14:
            [self setImageName:@"Pear.png" andChineseText:@"梨子" andEnglishText:@"Pear"];
            break;
        case 15:
            [self setImageName:@"Pineapple.png" andChineseText:@"菠萝" andEnglishText:@"Pineapple"];
            break;
        case 16:
            [self setImageName:@"Pitaya.png" andChineseText:@"火龙果" andEnglishText:@"Pitaya"];
            break;
        case 17:
            [self setImageName:@"Pomegranate.png" andChineseText:@"石榴" andEnglishText:@"Pomegranate"];
            break;
        case 18:
            [self setImageName:@"Strawberry.png" andChineseText:@"草莓" andEnglishText:@"Strawberry"];
            break;
        case 19:
            [self setImageName:@"Watermelon.png" andChineseText:@"西瓜" andEnglishText:@"Watermelon"];
            break;
        default:
            identifer = 0;
            [self setImageName:@"Apple.png" andChineseText:@"苹果" andEnglishText:@"Apple"];
            break;
    }
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    //create two button
    
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(600, 50, 250, 132) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn_ch];
    [btn_ch release];//???
    
    
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(700, 200, 250, 132) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_eng addTarget:self action:@selector(playFruitEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_eng];
    [btn_eng release];
    
    identifer++;
    mark2 = 1;
}

-(void)setImageName:(NSString*)iName andChineseText:(NSString*)chText andEnglishText:(NSString*)enText
{
    imageName = iName;
    button_ch_text = chText;
    button_eng_text = enText;
}

- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    if (mark2 == 1) {
        identifer--;
        identifer--;
    }
    else {
        identifer--;
    }
    switch (identifer) {
        case 0:
            [self setImageName:@"Apple.png" andChineseText:@"苹果" andEnglishText:@"Apple"];
            break;
        case 1:
            [self setImageName:@"Apricot.png" andChineseText:@"杏" andEnglishText:@"Apricot"];
            break;
        case 2:
            [self setImageName:@"Banana.png" andChineseText:@"香蕉" andEnglishText:@"Banana"];
            break;
        case 3:
            [self setImageName:@"Cherry.png" andChineseText:@"樱桃" andEnglishText:@"Cherry"];
            break;
        case 4:
            [self setImageName:@"Coconut.png" andChineseText:@"椰子" andEnglishText:@"Coconut"];
            break;
        case 5:
            [self setImageName:@"Durian.png" andChineseText:@"榴莲" andEnglishText:@"Durian"];
            break;
        case 6:
            [self setImageName:@"Fig.png" andChineseText:@"无花果" andEnglishText:@"Fig"];
            break;
        case 7:
            [self setImageName:@"Kiwifruit.png" andChineseText:@"猕猴桃" andEnglishText:@"Kiwifruit"];
            break;
        case 8:
            //mark
            [self setImageName:@"Lemon.png" andChineseText:@"柠檬" andEnglishText:@"Lemon"];
            break;
        case 9:
            [self setImageName:@"Loquat.png" andChineseText:@"枇杷" andEnglishText:@"Loquat"];
            break;
        case 10:
            [self setImageName:@"Mango.png" andChineseText:@"芒果" andEnglishText:@"Mango"];
            break;
        case 11:
            [self setImageName:@"Mangosteen.png" andChineseText:@"山竹" andEnglishText:@"Mangosteen"];
            break;
        case 12:
            [self setImageName:@"Muskmelon.png" andChineseText:@"香瓜" andEnglishText:@"Muskmelon"];
            break;
        case 13:
            [self setImageName:@"Pawpaw.png" andChineseText:@"木瓜" andEnglishText:@"Pawpaw"];
            break;
        case 14:
            [self setImageName:@"Pear.png" andChineseText:@"梨子" andEnglishText:@"Pear"];
            break;
        case 15:
            [self setImageName:@"Pineapple.png" andChineseText:@"菠萝" andEnglishText:@"Pineapple"];
            break;
        case 16:
            [self setImageName:@"Pitaya.png" andChineseText:@"火龙果" andEnglishText:@"Pitaya"];
            break;
        case 17:
            [self setImageName:@"Pomegranate.png" andChineseText:@"石榴" andEnglishText:@"Pomegranate"];
            break;
        case 18:
            [self setImageName:@"Strawberry.png" andChineseText:@"草莓" andEnglishText:@"Strawberry"];
            break;
        case 19:
            [self setImageName:@"Watermelon.png" andChineseText:@"西瓜" andEnglishText:@"Watermelon"];
            break;
        default:
            identifer = 19;
            [self setImageName:@"Watermelon.png" andChineseText:@"西瓜" andEnglishText:@"Watermelon"];
            break;
    }
    [contentImage setImage:[UIImage imageNamed:imageName]];
    [self createUpAnimation];
    [contentImage.layer addAnimation:animation forKey:@"move in"];
    
    //create two button
    
    UIButton * btn_ch = [self creatButtonWithFrame:CGRectMake(600, 50, 250, 132) tag:20 text:button_ch_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn_ch];
    [btn_ch release];
    
    
    UIButton * btn_eng = [self creatButtonWithFrame:CGRectMake(700, 200, 250, 132) tag:21 text:button_eng_text font:[UIFont systemFontOfSize:40] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor]];
    [btn_eng addTarget:self action:@selector(playFruitEngAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_eng];
    [btn_eng release];
    
    mark2 = 2;
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
-(void)playFruitEngAudio:(UIButton*)button
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end