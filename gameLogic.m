//
//  gameLogic.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "gameLogic.h"

@implementation gameLogic


- (BOOL)canPlaceMark:(NSInteger)mark atY:(NSInteger)y atX:(NSInteger)x
{
    return _marks[y][x]==0 && mark !=0;
}

- (void)updateJudge
{
    for (NSInteger i=0; i<_numLines; i++) {
        NSInteger m[3];
        for (NSInteger j=0; j<3; j++) {
            m[j] = _marks[_computeLines[i][j][0]][_computeLines[i][j][1]];
        }
        if (m[0]!=0 && m[1]==m[0] && m[2]==m[0]) {
            _isGameEnd = YES;
            _winner = m[0];
            return;
        }
    }
    
    if (_numPlacedMarks == 9) {
        _isGameEnd = YES;
        _winner = 0;
    }else{
        _isGameEnd = NO;
        _winner = 0;
    }
}

- (void)placeMark:(NSInteger)mark atY:(NSInteger)y atX:(NSInteger)x
{
    if (mark !=0 && _marks[y][x]==0) {
        _marks[y][x]=mark;
        _numPlacedMarks++;
        [self updateJudge];
    }
}


- (NSInteger) markAtY:(NSInteger)y atX:(NSInteger)x
{
    return _marks[y][x];
}

- (NSInteger) numPlacedMarks
{
    return _numPlacedMarks;
}

- (BOOL) calaiMark:(NSInteger)mark outputY:(NSInteger *)y outputX:(NSInteger *)x outputType:(NSInteger *)t
{
    if (_isGameEnd) {
        return NO;
    }
    
    NSInteger numChoice;
    NSInteger choice[24][2];
    
    //find the place that can help computer win
    numChoice = 0;
    for (NSInteger i=0; i<_numLines; i++) {
        NSInteger m[3];
        NSInteger numMark = 0;
        for (NSInteger j=0; j<3; j++) {
            m[j] = _marks [_computeLines[i][j][0]][_computeLines[i][j][1]];
            if (m[j]==mark) {
                numMark++;
            }
        }
        
        //if have two marks
        if (numMark==2) {
            for (NSInteger j=0; j<3; j++) {
                if (m[j]==0) {
                    choice[numChoice][0] = _computeLines[i][j][0];
                    choice[numChoice][1] = _computeLines[i][j][1];
                    numChoice++;
                }
            }
        }
        
    }
    
    if (numChoice >0) {
        NSInteger ran= arc4random_uniform(numChoice);
        *y = choice [ran][0];
        *x = choice [ran][1];
        *t = 1;
        return YES;
    }
    
    //find the spots the computer must block
    numChoice = 0;
    for (NSInteger i =0; i<_numLines; i++) {
        NSInteger m[3];
        NSInteger numPlace = 0;
        for (NSInteger j =0; j<3; j++) {
            m[j] = _marks[_computeLines[i][j][0]][_computeLines[i][j][1]];
            if (m[j] != 0) {
                numPlace++;
            }
        }
        
        if (numPlace == 2) {
            for (NSInteger j = 0; j < 3; j++) {
                // if they have the same mark
                if (m[j] == 0 && m[(j+1)%3] == m[(j+2)%3]) {
                    choice[numChoice][0] = _computeLines[i][j][0];
                    choice[numChoice][1] = _computeLines[i][j][1];
                    numChoice++;
                }
            }
        }

    }
    
    if (numChoice > 0) {
        NSInteger ran = arc4random_uniform(numChoice);
        *y = choice[ran][0];
        *x = choice[ran][1];
        *t = 2;
        return YES;
    }
    
    if (_marks[1][1] == 0) {
        *y = 1;
        *x = 1;
        *t = 3;
        return YES;
    }

    
    numChoice = 0;
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            if (_marks[y][x] != 0) {
                continue;
            }
            BOOL good = NO;
            for (NSInteger i = 0; i < _numLines; i++) {
                NSInteger m[3];
                BOOL hasenemy = NO;
                BOOL hasself = NO;
                BOOL hasthispoint = NO;
                for (NSInteger j = 0; j < 3; j++) {
                    if (_computeLines[i][j][0] == y && _computeLines[i][j][1] == x) {
                        hasthispoint = YES;
                    }
                    m[j] = _marks[_computeLines[i][j][0]][_computeLines[i][j][1]];
                    if (m[j] == mark) {
                        hasself = YES;
                    }
                    else if (m[j] != 0) {
                        hasenemy = YES;
                    }
                }
                if (hasthispoint && hasself && !hasenemy) {
                    good = YES;
                }
            }
            if (good) {
                choice[numChoice][0] = y;
                choice[numChoice][1] = x;
                numChoice++;
            }
        }
    }
    if (numChoice > 0) {
        NSInteger ran = arc4random_uniform(numChoice);
        *y = choice[ran][0];
        *x = choice[ran][1];
        *t = 4;
        return YES;
    }
    
    numChoice = 0;
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            if (_marks[y][x] == 0) {
                choice[numChoice][0] = y;
                choice[numChoice][1] = x;
                numChoice++;
            }
        }
    }
    if (numChoice > 0) {
        NSInteger ran = arc4random_uniform(numChoice);
        *y = choice[ran][0];
        *x = choice[ran][1];
        *t = 5;
        return YES;
    }
    return NO;
    
}

- (BOOL) isGameEnd
{
    return _isGameEnd;
}

- (NSInteger) winner
{
    return _winner;
}

- (void)clear
{
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            _marks[y][x] = 0;
        }
    }
    _numPlacedMarks = 0;
    _isGameEnd = NO;
    _winner = 0;
    self.currentUserMark = 0;
}

- (void)doInit
{
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            _marks[y][x] = 0;
        }
    }
    _numPlacedMarks = 0;
    _isGameEnd = NO;
    _winner = 0;
    self.currentUserMark = 0;
    
    _numLines = 8;
    NSInteger c = 0;
    for (NSInteger y = 0; y < 3; y++) {
        _computeLines[c][0][0] = y;
        _computeLines[c][0][1] = 0;
        _computeLines[c][1][0] = y;
        _computeLines[c][1][1] = 1;
        _computeLines[c][2][0] = y;
        _computeLines[c][2][1] = 2;
        c++;
    }
    for (NSInteger x = 0; x < 3; x++) {
        _computeLines[c][0][0] = 0;
        _computeLines[c][0][1] = x;
        _computeLines[c][1][0] = 1;
        _computeLines[c][1][1] = x;
        _computeLines[c][2][0] = 2;
        _computeLines[c][2][1] = x;
        c++;
    }
    _computeLines[c][0][0] = 0;
    _computeLines[c][0][1] = 0;
    _computeLines[c][1][0] = 1;
    _computeLines[c][1][1] = 1;
    _computeLines[c][2][0] = 2;
    _computeLines[c][2][1] = 2;
    c++;
    _computeLines[c][0][0] = 0;
    _computeLines[c][0][1] = 2;
    _computeLines[c][1][0] = 1;
    _computeLines[c][1][1] = 1;
    _computeLines[c][2][0] = 2;
    _computeLines[c][2][1] = 0;
    c++;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}




















@end
