//
//  Game.m
//  2048
//
//  Created by Rafael Mumme on 3/18/14.
//  Copyright (c) 2014 Rafael Mumme. All rights reserved.
//

#import "Game.h"
#import "Grid.h"
#import "Tile.h"

static int startTiles = 2;

@interface Game()

@property(nonatomic, retain) Grid *grid;

@end

@implementation Game

- (void)setup {
    
    self.grid = [Grid gridWithSize:4];
    
}

- (void)addStartTiles {
    for(int i=0;i<startTiles;i++) {
        [self addRandomTile];
    }
}

- (void)addRandomTile {
    if([self.grid cellsAvailable]) {
        int value = arc4random() < 0.9 ? 2 : 4;
        Tile *tile = [Tile tileWithPosition:[self.grid randomAvailableCell] andValue:value];
        [self.grid insertTile:tile];
    }
}

- (void)move {
    [self.grid prepareTiles];
}

@end
