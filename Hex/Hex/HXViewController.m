//
//  HXViewController.m
//  Hex
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import "HXViewController.h"
#import "HXBoard.h"

@interface HXViewController ()

@property HXBoard *board;

@property CGPoint touchStart;

@end

@implementation HXViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    // Create a board
    [self setBoardForShape:HXShapeHexPointUp];
    
    UIButton *square = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    square.frame = CGRectMake(20, 400, 50, 40);
    [square setTitle:@"Square" forState:UIControlStateNormal];
    [square addTarget:self action:@selector(squareBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:square];
    
    
    UIButton *hex1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hex1.frame = CGRectMake(90, 400, 100, 40);
    [hex1 setTitle:@"Hex - Side" forState:UIControlStateNormal];
    [hex1 addTarget:self action:@selector(hexSide:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hex1];
    
    
    UIButton *hex2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hex2.frame = CGRectMake(210, 400, 100, 40);
    [hex2 setTitle:@"Hex - Up" forState:UIControlStateNormal];
    [hex2 addTarget:self action:@selector(hexUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hex2];
    
    // add some gesture listeners - swipes don't handle diagonal moves
    //        UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //        gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    //        [self addGestureRecognizer:gestureLeft];
    //
    //        UISwipeGestureRecognizer *gestureUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //        gestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    //        [self addGestureRecognizer:gestureUp];
    //
    //
    //        UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //        gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    //        [self addGestureRecognizer:gestureRight];
    //
    //
    //        UISwipeGestureRecognizer *gestureDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //        gestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    //        [self addGestureRecognizer:gestureDown];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button responder

- (void)squareBoard:(id)sender
{
    [self setBoardForShape:HXShapeSquare];
}

- (void)hexUp:(id)sender
{
    [self setBoardForShape:HXShapeHexPointUp];
}

- (void)hexSide:(id)sender
{
    [self setBoardForShape:HXShapeHexPointSide];
}

- (void)setBoardForShape:(HXBoardShape)shape
{
    [self.board removeFromSuperview];
    self.board = nil;
    
    self.board = [[HXBoard alloc]initWithFrame:CGRectMake(20, 100, 280, 280) withSlots:CGPointMake(4, 4) andShape:shape];
    [self.view addSubview:self.board];
}

#pragma mark - swipes

- (void)swipe:(UISwipeGestureRecognizer*)gestureRecognizer
{
    HXBoardDirection boardDirection;
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            boardDirection = HXUp;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            boardDirection = HXLeft;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            boardDirection = HXRight;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            boardDirection = HXDown;
            break;
            
        default:
            boardDirection = HXLeft;
            break;
    }
    [self.board takeTurn:boardDirection];
}

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    self.touchStart = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchEnd = [touch locationInView:self.view];
    CGFloat adx = ABS(self.touchStart.x - touchEnd.x);
    CGFloat ady = ABS(self.touchStart.y - touchEnd.y);
    CGFloat dx = (self.touchStart.x - touchEnd.x)/adx;
    CGFloat dy = (self.touchStart.y - touchEnd.y)/ady;
    
    // normalize the movement?
    if (adx > ady) {
        ady = ady/adx;
        adx = 1;
    } else if (adx < ady) {
        adx = adx/ady;
        ady = 1;
    } else {
        adx = 1;
        ady = 1;
    }
    
    
    CGPoint movement = CGPointMake(adx*dx, ady*dy);
    
    HXBoardDirection boardDirection = [self.board directionForMovement:movement];
    [self.board takeTurn:boardDirection];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
