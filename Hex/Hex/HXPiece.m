//
//  HXPiece.m
//  Hex
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import "HXPiece.h"
#import <QuartzCore/QuartzCore.h>

@interface HXPiece()

@property (nonatomic, strong) UILabel *label;

@end

@implementation HXPiece

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label = [[UILabel alloc]initWithFrame:self.frame];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"Arial" size:24.0f];
        self.label.textColor = [UIColor darkGrayColor];
        [self addSubview:self.label];
        
            }
    return self;
}

// Create a bezierPath for shapes to use as a mask
- (UIBezierPath *)getPathForShape:(HXBoardShape)shape
{
    UIBezierPath *polyPath = nil;
    if (shape == HXShapeHexPointUp) {
        polyPath = [UIBezierPath bezierPath];
        [polyPath moveToPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.height/2)];
        for (int i = 1; i <= 6; ++i) {
            CGFloat x, y;
            
            CGFloat fXValue_ = self.frame.size.height/2;
            x = fXValue_ * sinf(i * 2.0 * M_PI / 6.0);
            y = fXValue_ * cosf(i * 2.0 * M_PI / 6.0);
            
            [polyPath addLineToPoint:CGPointMake(self.center.x + x, self.center.y + y)];
        }
        [polyPath closePath];
    } else if (shape == HXShapeHexPointSide) {
        polyPath = [UIBezierPath bezierPath];
        [polyPath moveToPoint:CGPointMake(self.center.x + self.frame.size.height/2, self.center.y)];
        for (int i = 2; i <= 7; ++i) {
            CGFloat x, y;
            
            CGFloat fXValue_ = self.frame.size.height/2;
            x = fXValue_ * sinf(i * 2.0 * M_PI / 6.0 + M_PI/6.0);
            y = fXValue_ * cosf(i * 2.0 * M_PI / 6.0 + M_PI/6.0);
            
            [polyPath addLineToPoint:CGPointMake(self.center.x + x, self.center.y + y)];
        }
        [polyPath closePath];
    } else {
        polyPath = [UIBezierPath bezierPathWithRect:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame)-10)];
    }
    return polyPath;
}

- (void)setShape:(HXBoardShape)shape
{
    // Clear any old masks
    self.layer.mask = nil;
    
    UIBezierPath *bezierPath = [self getPathForShape:shape];
    if (bezierPath) {
        // Create a shape layer
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.frame;
        
        // Set the path of the mask layer to be the Bezier path we calculated earlier
        maskLayer.path = bezierPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
    
    _shape = shape;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    self.label.text = [NSString stringWithFormat:@"%ld",value];
    
    UIColor *color;
    switch (value) {
        case 2:
            color = [UIColor colorWithRed:0.0f
                                    green:0.99f
                                     blue:0.99f
                                    alpha:1];
            break;
        case 4:
            color = [UIColor colorWithRed:0.0f
                                    green:0.95f
                                     blue:0.95f
                                    alpha:1];
            break;
        case 8:
            color = [UIColor colorWithRed:0.0f
                                    green:0.9f
                                     blue:0.9f
                                    alpha:1];
            break;
        case 16:
            color = [UIColor colorWithRed:0.0f
                                    green:0.85f
                                     blue:0.85f
                                    alpha:1];
            break;
        case 32:
            color = [UIColor colorWithRed:0.0f
                                    green:0.8f
                                     blue:0.8f
                                    alpha:1];
            break;
        case 64:
            color = [UIColor colorWithRed:0.0f
                                    green:0.75f
                                     blue:0.75f
                                    alpha:1];
            break;
        case 128:
            color = [UIColor colorWithRed:0.0f
                                    green:0.7f
                                     blue:0.7f
                                    alpha:1];
            break;
        case 256:
            color = [UIColor colorWithRed:0.0f
                                    green:0.65f
                                     blue:0.65f
                                    alpha:1];
            break;
            
        case 512:
            color = [UIColor colorWithRed:0.0f
                                    green:0.60f
                                     blue:0.60f
                                    alpha:1];
            break;
            
        case 1024:
            color = [UIColor colorWithRed:0.0f
                                    green:0.55f
                                     blue:0.55f
                                    alpha:1];
            break;
        case 2048:
        {
            color = [UIColor colorWithRed:0.0f
                                    green:0.50f
                                     blue:0.50f
                                    alpha:1];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WINNER"
                                                           message:@"You won!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"ok"
                                                 otherButtonTitles: nil];
            [alert show];
        }
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    self.backgroundColor = color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
