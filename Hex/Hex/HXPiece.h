//
//  HXPiece.h
//  Hex
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBoard.h"

@interface HXPiece : UIView

@property (nonatomic) NSInteger value;
@property (nonatomic) HXBoardShape shape;
@property BOOL empty;
@property BOOL mergable;
@property BOOL animateable;

@end
