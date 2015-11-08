//
//  gameLogic.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gameLogic : NSObject
{
    NSInteger _numLines;
    NSInteger _computeLines[8][3][2];
    
    //nothing - 0
    //X" - 1, 'O' -2
    // [y][x] format
    NSInteger _marks[3][3];
    NSInteger _numPlacedMarks;
    BOOL _isGameEnd;
    NSInteger _winner;
}

@property (nonatomic) NSInteger currentUserMark;
- (BOOL) canPlaceMark: (NSInteger) mark atY: (NSInteger)y atX: (NSInteger)x;
- (void) placeMark: (NSInteger) mark atY: (NSInteger)y atX: (NSInteger)x;
- (NSInteger) markAtY: (NSInteger)y atX:(NSInteger)x;
- (NSInteger) numPlacedMarks;
- (BOOL) calaiMark: (NSInteger) mark outputY: (NSInteger *)y outputX: (NSInteger *)x outputType: (NSInteger *)t;
- (BOOL) isGameEnd;
- (NSInteger) winner;
- (void) clear;

@end
