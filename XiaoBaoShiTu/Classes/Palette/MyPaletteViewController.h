//
//  MyPaletteViewController.h
//  XiaoBaoShiTu
//
//  Created by ldci on 13-9-3.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"

@interface MyPaletteViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
{
	UILabel* labelColor;
	UILabel* labelLoanshift;
	CGPoint MyBeganpoint;
	CGPoint MyMovepoint;
	int Segment;
	int SegmentWidth;
	//----------------
	UIImageView* pickImage;
	
	UISegmentedControl* WidthButton;
	UISegmentedControl* ColorButton;
    
}
@property int Segment;
@property (nonatomic,retain)IBOutlet UILabel* labelColor;
@property (nonatomic,retain)IBOutlet UILabel* labelLoanshift;
@property (nonatomic,retain) UIPopoverController * popVCtrl;

-(IBAction)myAllColor;
-(IBAction)myAllWidth;
-(IBAction)myPalttealllineclear;
-(IBAction)LineFinallyRemove;
-(IBAction)myRubberSeraser;

-(void)segmentColor;
-(void)segmentWidth;
//=====================
-(IBAction)callCame;
-(IBAction)captureScreen;
@end

