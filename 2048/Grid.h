//
//  Grid.h
//  2048
//
//  Created by Rafael Mumme on 3/18/14.
//  Copyright (c) 2014 Rafael Mumme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Grid : NSObject

+ (Grid *)gridWithSize:(int)gridSize;

- (BOOL)cellsAvailable;
- (CGPoint)randomAvailableCell;
- (void)insertTile:(Tile *)tile;
- (void)removeTile:(Tile *)tile;

@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,retain) Tile *emptyTile;

- (void)moveTile:(Tile *)tile toPosition:(CGPoint)position;
- (void)prepareTiles;

@end
