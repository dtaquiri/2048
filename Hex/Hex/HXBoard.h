//
//  HXBoard.h
//  Hex
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HXUp,
    HXDown,
    HXLeft,
    HXRight,
    HXUPLeft,
    HXDownLeft,
    HXUpRight,
    HXDownRight,
    HXNone
} HXBoardDirection;

typedef enum : NSUInteger {
    HXShapeSquare,
    HXShapeHexPointUp,
    HXShapeHexPointSide
}HXBoardShape;

@interface HXBoard : UIView


- (instancetype)initWithFrame:(CGRect)frame withSlots:(CGPoint)slots andShape:(HXBoardShape)shape;

- (HXBoardDirection)directionForMovement:(CGPoint)movement;
- (void)takeTurn:(HXBoardDirection)boardDirection;


-(BOOL)move:(HXBoardDirection)direction;
-(void)addRandomPiece;

@end
