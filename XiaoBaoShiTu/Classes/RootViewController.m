//
//  RootViewController.m
//  XiaoBaoShiTu
//
//  Created by longanxiang_iMac on 13-8-24.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import "RootViewController.h"
#import "AnimalViewController.h"
#import "SportViewController.h"
#import "FruitViewController.h"
#import "MyPaletteViewController.h"

@interface RootViewController ()
{
    AVAudioPlayer* bgAudioPlayer;
}

@property (nonatomic, retain) NSMutableArray * pages;
@property (nonatomic, retain) UIScrollView * picScrollView;

@end

@implementation RootViewController

@synthesize pages, picScrollView;
- (void)dealloc
{
    self.pages = nil;
    self.picScrollView = nil;
//    [bgAudioPlayer release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape.png"]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor lightGrayColor];
    [self creatContentView];
    
    //多线程 音乐
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//    ^{
//        NSError * err = nil;
//        NSString * path = [[NSBundle mainBundle]pathForResource:@"01 Les monstres" ofType:@"m4a"];
//        NSURL * url = [NSURL fileURLWithPath:path];
//        
//        bgAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
//        if (nil == bgAudioPlayer) {
//            NSLog(@"Error: %@", [err localizedDescription]);
//        }
//        [bgAudioPlayer prepareToPlay];
//        bgAudioPlayer.numberOfLoops = -1;
//        bgAudioPlayer.volume = 1.0;
//        [bgAudioPlayer play];
//    });

    [self loadChild];
//    [self isFirstLanuch];
}



//第一次安装应用，加引导页
//- (void)isFirstLanuch
//{
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunching"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"isFirstLaunching"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        pages = [[NSMutableArray alloc] initWithObjects:@"引导页1.jpg",@"引导页1.jpg",@"引导页1.jpg",nil];
//        if (self.picScrollView == nil) {
//            CGRect scrollViewFrame = CGRectMake(0.0, 0.0, 1024, 748);
//            UIScrollView * pic = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
//            self.picScrollView = pic;
//            [pic release];
//        }
//        picScrollView.delegate = self;
//        picScrollView.pagingEnabled = YES;
//        picScrollView.showsHorizontalScrollIndicator = NO;
//        picScrollView.showsVerticalScrollIndicator = NO;
//        picScrollView.scrollsToTop = NO;
//        CGRect frame = picScrollView.frame;
//        picScrollView.contentSize = CGSizeMake(frame.size.width * ([pages count]+1), frame.size.height);
//        NSInteger x_position = 0;
//        for (int i = 0; i < [pages count]; i++) {
//            UIImageView * newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x_position, 0.0, 1024, 748)];
//            //[newImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[pages objectAtIndex:i] ofType:nil]]];
//            newImageView.image = [UIImage imageNamed:[pages objectAtIndex:i]];
//            [picScrollView addSubview:newImageView];
//            [newImageView release];
//            x_position += 1024;
//        }
//        [self.view addSubview:picScrollView];
//        [self.view bringSubviewToFront:picScrollView];
//    }
//    
//}

-(void)loadChild
{
    NSMutableArray * child = [NSMutableArray array];
	for (int i = 1; i < 8; i++)
		[child addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"child%d", i] ofType:@"png"]]];
	
	UIImageView * childView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 511, 111, 131)];
	childView.tag = 300;
	childView.animationImages = child;
	childView.animationDuration = 1.0f;
	[self.view addSubview:childView];
	[childView startAnimating];
	[childView release];
	
}


/** 
 scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, iPhone5?420+88:420)];
 scrView.backgroundColor = [UIColor clearColor];
 scrView.bounces = YES;
 CGSize subSize = [self.subString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:UILineBreakModeWordWrap];
 CGSize conSize = [self.contentString sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:UILineBreakModeWordWrap];
 SL_Log(@"subSize=%f   conSize=%f",subSize.height, conSize.height);
 scrView.contentSize = CGSizeMake(320, 50+subSize.height+conSize.height);
 scrView.showsHorizontalScrollIndicator = NO;
 scrView.showsVerticalScrollIndicator = YES;
 scrView.scrollsToTop = YES;
 scrView.pagingEnabled = NO;
 [self.view addSubview:self.scrView];
 
 **/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIButton *)creatButtonWithFrame:(CGRect)frame tag:(NSInteger)tag text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.tag = tag;
    button.titleLabel.font = font;
    button.backgroundColor = bgColor;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)creatContentView
{
    UIButton * btn_left = [self creatButtonWithFrame:CGRectMake(50, 380, 150, 247) tag:5 text:@"画板" font:[UIFont systemFontOfSize:30] textColor:[UIColor redColor] backgroundColor:[UIColor clearColor]];
    [btn_left setBackgroundImage:[UIImage imageNamed:@"Plate.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn_left];
    [btn_left release];
    
    UIButton * btn_dh = [self creatButtonWithFrame:CGRectMake(220, 150, 120, 140) tag:6 text:@"动物" font:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    [btn_dh setBackgroundImage:[UIImage imageNamed:@"animalBallBtnUp.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn_dh];
    [btn_dh release];
    
    //rope view 1
    UIImageView* dh_rope_view = [[[UIImageView alloc]initWithFrame:CGRectMake(220, 290, 120, 101)]autorelease];
    [dh_rope_view setImage:[UIImage imageNamed:@"animalBallBtnDown.png"]];
    [self.view addSubview:dh_rope_view];
    [dh_rope_view release];
    
    UIButton * btn_sg = [self creatButtonWithFrame:CGRectMake(470, 224, 150, 170) tag:7 text:@"水果" font:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    [btn_sg setBackgroundImage:[UIImage imageNamed:@"fruitBallBtnUp.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn_sg];
    [btn_sg release];
    
    //rope view 2
    UIImageView* sg_rope_view = [[[UIImageView alloc]initWithFrame:CGRectMake(470, 394, 150, 125)]autorelease];
    [sg_rope_view setImage:[UIImage imageNamed:@"fruitBallBtnDown.png"]];
    [self.view addSubview:sg_rope_view];
    [sg_rope_view release];
    
    UIButton * btn_right = [self creatButtonWithFrame:CGRectMake(720, 160, 150, 174) tag:8 text:@"体育" font:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    [btn_right setBackgroundImage:[UIImage imageNamed:@"sportBallBtnUp.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn_right];
    [btn_right release];
    
    //rope view 3
    UIImageView* right_rope_view = [[[UIImageView alloc]initWithFrame:CGRectMake(720, 334, 150, 59)]autorelease];
    [right_rope_view setImage:[UIImage imageNamed:@"sportBallBtnDown.png"]];
    [self.view addSubview:right_rope_view];
    [right_rope_view release];

}

- (void)buttonClicked:(UIButton *)button
{
    NSLog(@"buttonClicked::::::%d", button.tag);
    NSInteger constant = button.tag - 5;
    UIViewController * controller = nil;
    switch (constant) {
        case 0:{
            controller = [[MyPaletteViewController alloc] initWithNibName:@"MyPaletteViewController" bundle:nil];
        }
            break;
            
        case 1:{
            controller = [[AnimalController alloc] init];
        }
            break;
            
        case 2:{
            controller = [[FruitViewController alloc] init];
        }
            break;
        case 3:{
            controller = [[SportViewController alloc] init];
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.picScrollView){
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = scrollView.contentOffset.x / pageWidth;
        if (page >= [pages count]) {
            [picScrollView removeFromSuperview];
        }
    }
}


@end
