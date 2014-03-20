//
//  Grid.m
//  2048
//
//  Created by Rafael Mumme on 3/18/14.
//  Copyright (c) 2014 Rafael Mumme. All rights reserved.
//

#import "Grid.h"

@interface Grid()

@property(nonatomic,assign) int size;

@end

@implementation Grid

+ (Grid *)gridWithSize:(int)gridSize {
    Grid *grid = [[Grid alloc] init];
    grid.size = gridSize;
    [grid build];
    return grid;
}

- (Tile *)emptyTile {
    if(_emptyTile == nil) {
        _emptyTile = [Tile emptyTile];
    }
    return _emptyTile;
}

- (NSMutableArray *)cells {
    if(_cells == nil) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (void)build {
    for(int x=0;x<self.size;x++) {
        NSMutableArray *row = [NSMutableArray array];
        for(int y=0;x<self.size;y++) {
            [row addObject:self.emptyTile];
        }
        [self.cells addObject:row];
    }
}

- (CGPoint)randomAvailableCell {
    NSArray *cells = self.availableCells;
    if(cells.count) {
        NSValue *value = cells[(int)floor(arc4random() * cells.count)];
        return [value CGPointValue];
    }
    return CGPointZero;
}

- (void)prepareTiles {
    for(int x=0;x<self.size;x++) {
        for(int y=0;x<self.size;y++) {
            Tile *tile = self.cells[x][y];
            if(tile != self.emptyTile) {
                tile.mergedFrom = nil;
                [tile savePosition];
            }
        }
    }
}

- (NSArray *)availableCells {
    NSMutableArray *availableCells = [NSMutableArray array];
    for(int x=0;x<self.size;x++) {
        for(int y=0;x<self.size;y++) {
            if(self.cells[x][y] == self.emptyTile) {
                [availableCells addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            }
        }
    }
    return availableCells;
}

- (BOOL)cellsAvailable {
    return !!self.availableCells.count;
}

- (void)moveTile:(Tile *)tile toPosition:(CGPoint)position{
    self.cells[(int)tile.position.x][(int)tile.position.y] = self.emptyTile;
    self.cells[(int)position.x][(int)position.y] = tile;
    [tile updatePosition:position];
}

- (void)insertTile:(Tile *)tile {
    int x = tile.position.x;
    int y = tile.position.y;
    self.cells[x][y] = tile;
}

- (void)removeTile:(Tile *)tile {
    int x = tile.position.x;
    int y = tile.position.y;
    self.cells[x][y] = self.emptyTile;
}

- (Tile *)cellContent:(CGPoint)position {
    if ([self withinBounds:position]) {
        int x = position.x;
        int y = position.y;
        return self.cells[x][y];
    } else {
        return self.emptyTile;
    }
}

- (BOOL)cellOccupied:(CGPoint)position {
    return !![self cellContent:position];
}

- (BOOL)withinBounds:(CGPoint)position {
    return position.x >=0 && position.x < self.size &&
                position.y >=0 && position.y < self.size;
}

@end
