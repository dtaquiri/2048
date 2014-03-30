//
//  HXBoard.m
//  Hex
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import "HXBoard.h"
#import "HXPiece.h"

@interface HXBoard()

@property (nonatomic, strong) NSNumber *xSlots;
@property (nonatomic, strong) NSNumber *ySlots;
@property CGPoint slots;
@property (nonatomic, strong) NSMutableDictionary *board;
@property (nonatomic, strong) NSMutableArray *empty;
@property CGSize slotSize;


@property HXBoardShape shape;

@end

@implementation HXBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withSlots:CGPointMake(5, 5) andShape:HXShapeSquare];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withSlots:(CGPoint)slots andShape:(HXBoardShape)shape
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        self.xSlots = [NSNumber numberWithFloat:slots.x];
        self.ySlots = [NSNumber numberWithFloat:slots.y];
        
        NSUInteger boardSize = self.xSlots.integerValue * self.ySlots.integerValue;
        
        self.slotSize = CGSizeMake(CGRectGetWidth(self.frame)/self.xSlots.floatValue,
                                    CGRectGetHeight(self.frame)/self.ySlots.floatValue);
        
        self.board = [NSMutableDictionary dictionaryWithCapacity:boardSize];
        self.shape = shape;
        
        // Create an array of board indexes that are empty -- all at the start
        self.empty = [NSMutableArray arrayWithCapacity:boardSize];
        for (int i = 0; i < boardSize; i++) {
            self.empty[i] = [NSNumber numberWithInteger:i];
        }
        
        
        // Randomly add two pieces
        [self addRandomPiece];
        [self addRandomPiece];
    }
    return self;
}

- (NSString *)description
{
    NSString *textBoard = @"\n";
    for (int j = 0; j < self.xSlots.integerValue; j++) {
        for (int i = 0; i < self.ySlots.integerValue; i++) {
            NSNumber *index = [self logicalPointToIndex:CGPointMake(i, j)];
            if (self.board[index]) {
                HXPiece *piece = self.board[index];
                textBoard = [textBoard stringByAppendingFormat:@"[%d]",piece.value];
            } else {
                textBoard = [textBoard stringByAppendingFormat:@"[ ]"];
            }
        }
        textBoard = [textBoard stringByAppendingFormat:@"\n"];
    }
    return textBoard;
}


/* 
 * get the index of the piece to compare when the board moves in direction
 */
- (NSNumber*)getComparisonIndexFor:(NSNumber*)index in:(HXBoardDirection)direction
{
    CGPoint point = [self indexToLogicalPoint:index];
    
    CGPoint moveDirection;
    switch (direction) {
            
        case HXDown:
            // Disable up/down on HXShapeHexPointUp
            if (self.shape == HXShapeHexPointUp) {
                moveDirection = CGPointMake(0, 0);
            } else {
                moveDirection = CGPointMake(0, -1);
            }
            break;
            
        case HXLeft:
            // Disable left/right on HXShapeHexPointSide
            if (self.shape == HXShapeHexPointSide) {
                moveDirection = CGPointMake(0, 0);
            } else {
                moveDirection = CGPointMake(1, 0);
            }
            break;
            
        case HXRight:
            // Disable left/right on HXShapeHexPointSide
            if (self.shape == HXShapeHexPointSide) {
                moveDirection = CGPointMake(0, 0);
            } else {
                moveDirection = CGPointMake(-1, 0);
            }
            break;
            
        case HXUp:
            // Disable up/down on HXShapeHexPointUp
            if (self.shape == HXShapeHexPointUp) {
                moveDirection = CGPointMake(0, 0);
            } else {
                moveDirection = CGPointMake(0, 1);
            }
            break;
            
        case HXUPLeft:
            moveDirection = CGPointMake(1, 1);
            
            // for hex shaped boards diagonal movement is strange
            if (self.shape == HXShapeHexPointUp && fmod(point.y, 2) != 0) {
                moveDirection.x = 0;
            }
            
            if (self.shape == HXShapeHexPointSide && fmod(point.x, 2) != 0) {
                moveDirection.y = 0;
            }
            
            break;
            
        case HXDownLeft:
            moveDirection = CGPointMake(1, -1);
            
            // for hex shaped boards diagonal movement is strange
            if (self.shape == HXShapeHexPointUp && fmod(point.y, 2) != 0) {
                
                moveDirection.x = 0;
                
            } else if (self.shape == HXShapeHexPointSide && fmod(point.x, 2) == 0) {
                
                moveDirection.y = 0;
            }
            break;
            
        case HXUpRight:
            moveDirection = CGPointMake(-1, 1);
            
            // for hex shaped boards diagonal movement is strange
            if (self.shape == HXShapeHexPointUp && fmod(point.y, 2) == 0) {
                moveDirection.x = 0;
                
            } else if (self.shape == HXShapeHexPointSide && fmod(point.x, 2) != 0) {
                
                moveDirection.y = 0;
            }
            break;
            
        case HXDownRight:
            moveDirection = CGPointMake(-1, -1);
            
            // for hex shaped boards diagonal movement is strange
            if (self.shape == HXShapeHexPointUp && fmod(point.y, 2) == 0) {
                moveDirection.x = 0;
                
            } else if (self.shape == HXShapeHexPointSide && fmod(point.x, 2) == 0) {
                
                moveDirection.y = 0;
            }
            break;
            
        default:
            moveDirection = CGPointMake(0, 0);
            break;
    }
    
    // Grab the neighbor piece to move -- check to make sure its in bounds
    CGPoint comparePoint = CGPointMake(point.x+moveDirection.x, point.y+moveDirection.y);
    NSNumber *compareIndex;
    
    // If the new compare point will be out of bounds return the original index
    if (comparePoint.x < 0 || comparePoint.x >= self.xSlots.integerValue ||
        comparePoint.y < 0 || comparePoint.y >= self.ySlots.integerValue) {
        compareIndex = index;
    } else {
        compareIndex = [self logicalPointToIndex:comparePoint];
    }
    
    return compareIndex;
}

/*
 * Calculate HXBoardDirection for the normalized movement
 */
- (HXBoardDirection)directionForMovement:(CGPoint)movement
{
    CGFloat diagonalThreashold = .3f;
    CGFloat threashold = .5f;
    
    HXBoardDirection boardDirection;
    
    if (movement.x < -1*diagonalThreashold
        && movement.y < -1*diagonalThreashold) {
        boardDirection = HXDownRight;
    } else if (movement.x < -1*diagonalThreashold && movement.y > diagonalThreashold) {
        boardDirection = HXUpRight;
    } else if (movement.x > diagonalThreashold && movement.y > diagonalThreashold) {
        boardDirection = HXUPLeft;
    } else if (movement.x > diagonalThreashold && movement.y < -1*diagonalThreashold) {
        boardDirection = HXDownLeft;
    } else if (movement.x < -1*threashold) {
        boardDirection = HXRight;
    } else if (movement.x > threashold) {
        boardDirection = HXLeft;
    } else if (movement.y < -1*threashold) {
        boardDirection = HXDown;
    } else if (movement.y > threashold) {
        boardDirection = HXUp;
    } else {
        boardDirection = HXNone;
    }
    return boardDirection;
}

// Moves all pieces in the given direction and adds a new random piece
- (void)takeTurn:(HXBoardDirection)boardDirection
{
    if (boardDirection != HXNone) {
        BOOL moved = [self move:boardDirection];
        
        if (moved) {
            // TODO handle the new piece better
            // delay the new piece by 1/4 a second
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addRandomPiece];
            });
        }
    }
}

// Returns true if any move was made
- (BOOL)move:(HXBoardDirection)direction
{
    // X can always start at 0 unless we are moving the board right
    int xStart = 0;
    int dx = 1;
    NSInteger xEnd = self.xSlots.integerValue;
    if (direction == HXRight || direction == HXUpRight || direction == HXDownRight) {
        xStart = self.xSlots.integerValue - 1;
        dx = -1;
        xEnd = -1;
    }
    
    // Y can always start at 0 unless we are moving the board down
    int yStart = 0;
    int dy =1;
    int yEnd = self.xSlots.integerValue;
    if (direction == HXDown || direction == HXDownLeft || direction == HXDownRight) {
        yStart = self.ySlots.integerValue-1;
        dy = -1;
        yEnd = -1;
    }
    
    BOOL madeMoves = NO;
    int moves = 0;
    // Loop through the board until no more moves can be made
    do {
        moves = 0;
        // NOTE this will only work if dx and dy are -1 or 1
        for (int x = xStart; x != xEnd ; x+=dx) {
            for (int y = yStart; y != yEnd; y+=dy) {
                NSNumber *index = [self logicalPointToIndex:CGPointMake(x, y)];
                NSNumber *comapreIndex = [self getComparisonIndexFor:index in:direction];
                
                // Do nothing if the compareIndex is the same
                if ([index isEqual:comapreIndex]) {
                    continue;
                }
                
                BOOL moved = [self merge:comapreIndex into:index];
                if (moved) {
                    moves++;
                    madeMoves = YES;
                }
            }
            // TODO handle movement animation - this just forces an update which re-draws everything
            [self setNeedsLayout];
        }
    } while (moves > 0);
    
    // Reset mergableness
    for (HXPiece *piece in self.board.allValues) {
        piece.mergable = YES;
        piece.animateable = YES;
    }
    
    return madeMoves;
}

- (void)addRandomPiece
{
    HXPiece *piece = [[HXPiece alloc]initWithFrame:CGRectMake(0, 0, self.slotSize.width, self.slotSize.height)];
    piece.shape = self.shape;
    piece.value = 2;
    piece.mergable = YES;
    // TODO -- animateable is a hack - set animateable to no so the new piece doesn't fly in from out of no where
    piece.animateable = NO;
    [self addSubview:piece];
    
    // Choose a random empty index
    NSUInteger random =  arc4random()%self.empty.count;
    NSNumber *emptyIndex = self.empty[random];
    
    NSAssert(self.board[emptyIndex] == nil, @"emptyIndex was not correct space is not empty");
    
    // Place the new piece on the board and remove it form the empty array
    self.board[emptyIndex] = piece;
    [self.empty removeObjectAtIndex:random];
}

// Returns true if a merge or move happens
- (BOOL)merge:(NSNumber*)movingIndex into:(NSNumber*)destinationIndex
{
    HXPiece *movingPiece = self.board[movingIndex];
    HXPiece *destinationPiece = self.board[destinationIndex];
    
    // If both pieces exist compare their values
    if (movingPiece && destinationPiece) {
        if (movingPiece.value == destinationPiece.value &&
            movingPiece.mergable && destinationPiece.mergable) {
            
            // add the values
            destinationPiece.value = movingPiece.value+destinationPiece.value;
            destinationPiece.mergable = NO;
            
            // remove the old movingPiece
            [self.board removeObjectForKey:movingIndex];
            [movingPiece removeFromSuperview];
            
            // re-add it to the empty list
            [self.empty addObject:movingIndex];
            return true;
        }
    }
    
    if (movingPiece && !destinationPiece) {
        // There wasn't a destination piece so we can just move
        
        // remove the piece from the board
        [self.board removeObjectForKey:movingIndex];
        
        // place it in the destinationIndex
        self.board[destinationIndex] = movingPiece;
        
        // remove the destination from empty
        [self.empty removeObject:destinationIndex];
        
        // add the new empty space
        [self.empty addObject:movingIndex];
        return true;
    }
    return false;
}

/* 
 * Convert the logical x,y point to array index
 */
- (NSNumber *)logicalPointToIndex:(CGPoint)point
{
    NSInteger index = point.y * self.xSlots.floatValue + point.x;
    return [NSNumber numberWithInteger:index];
}

/*
 * Convert the array index to logical x,y point
 */
- (CGPoint)indexToLogicalPoint:(NSNumber *)index
{
    NSUInteger x = index.integerValue % self.xSlots.integerValue;
    NSUInteger y = index.floatValue / self.ySlots.floatValue;
    return CGPointMake(x, y);
}

/*
 * Convert the array index to drawing center x,y point
 */
- (CGPoint)indexToDrawPoint:(NSNumber *)index
{
    CGPoint logicalPoint = [self indexToLogicalPoint:index];
    CGSize offset = CGSizeMake(-self.slotSize.width/2, -self.slotSize.height/2);
    
    // For pointUp Hex boards the rows shoule be alternately offset
    if (self.shape == HXShapeHexPointUp) {
        offset.width += (fmodf(logicalPoint.y,2) == 0) ? -1*offset.width/2:offset.width/2;
    } else if (self.shape == HXShapeHexPointSide) {
        offset.height += (fmodf(logicalPoint.x,2) == 0) ? -1*offset.height/2:offset.height/2;
    }
    
    return CGPointMake((logicalPoint.x+1)*self.slotSize.width+offset.width,
                       (logicalPoint.y+1)*self.slotSize.height+offset.height);
}

/*
 * Go through all the pieces currently on the board and set their x,y points
 */
- (void)layoutSubviews
{
    [self.board enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, HXPiece *piece, BOOL *stop) {
        if (piece.animateable) {
            
            [UIView animateWithDuration:0.3f animations:^{
                piece.center = [self indexToDrawPoint:key];
            }];
        } else {
            piece.center = [self indexToDrawPoint:key];
        }
    }];
}

@end
