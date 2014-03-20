//
//  Tile.m
//  2048
//
//  Created by Rafael Mumme on 3/18/14.
//  Copyright (c) 2014 Rafael Mumme. All rights reserved.
//

#import "Tile.h"

@implementation Tile

+ (Tile *)emptyTile {
    Tile *tile = [[Tile alloc] init];
    tile.isEmpty = YES;
    return tile;
}

+ (Tile *)tileWithPosition:(CGPoint)tilePosition andValue:(int)value {
    Tile *tile = [[Tile alloc] init];
    tile.position = CGPointMake(tilePosition.x, tilePosition.y);
    tile.value = value;
    tile.isEmpty = NO;
    return tile;
}

- (void)savePosition {
    self.previousPosition = CGPointMake(self.position.x, self.position.y);
}

- (void)updatePosition:(CGPoint)newPosition {
    self.position = CGPointMake(newPosition.x, newPosition.y);
}

@end
