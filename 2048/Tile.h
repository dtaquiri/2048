//
//  Tile.h
//  2048
//
//  Created by Rafael Mumme on 3/18/14.
//  Copyright (c) 2014 Rafael Mumme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject

@property(nonatomic,retain) NSDictionary *mergedFrom;

@property(nonatomic,assign) BOOL isEmpty;

@property(nonatomic,assign) CGPoint position;
@property(nonatomic,assign) CGPoint previousPosition;

@property(nonatomic,assign) int value;

- (void)updatePosition:(CGPoint)newPosition;

+ (Tile *)emptyTile;

+ (Tile *)tileWithPosition:(CGPoint)tilePosition andValue:(int)value;

- (void)savePosition;

@end
