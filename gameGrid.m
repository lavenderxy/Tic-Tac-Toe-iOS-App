//
//  gameGrid.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "gameGrid.h"

@implementation gameGrid


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch == nil) {
        NSLog(@"nil touch in VGameGrid touchesBegan");
    }
    
    CGPoint touchLocate = [touch locationInView:self];
    CGFloat ox = self.bounds.origin.x;
    CGFloat oy = self.bounds.origin.y;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    NSInteger x = (NSInteger)floor(((touchLocate.x - ox) / width - 0.05) / 0.3);
    NSInteger y = (NSInteger)floor(((touchLocate.y - oy) / height - 0.05) / 0.3);
    if (x<0 || x>=3 || y<0 || y>=3) {
        return;
    }
    NSInteger userMark = _gameLogical.currentUserMark;
    if (userMark == 0) {
        if (self.delegate != nil) {
            [self.delegate delegateGameGridWronglyTouched:self];
        }
        return;
    }
    else if (![_gameLogical canPlaceMark:userMark atY:y atX:x]){
        if (self.delegate !=nil) {
            [self.delegate delegateGameGridWrongPlaced:userMark forSender:self];
        }
        return;
    }
    else{
        if (self.delegate != nil) {
            [self.delegate delegateGameGridShouldPlace:userMark atY:y atX:x forSender:self];
        }
        return;
    }
    
}

- (void) updategrid
{
    [self setNeedsDisplay];
}

- (void)doInit
{
    if (!_hasInit) {
        _hasInit = YES;
        _gameLogical = nil;
    }
}

- (void) initGameLogic:(gameLogic *)gameLogic
{
    _gameLogical = gameLogic;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doInit];
    }
    return self;
}



- (void) drawRect:(CGRect)rect
{
    CGFloat ox = rect.origin.x;
    CGFloat oy = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    for (NSInteger i = 0; i < 4; i++)
    {
        CGContextMoveToPoint(context, ox + (0.05 + 0.3 * i) * width, oy + 0.05 * height);
        CGContextAddLineToPoint(context, ox + (0.05 + 0.3 * i) * width, oy + 0.95 * height);
    }
    CGContextSetLineWidth(context, 0.01 * width);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    for (NSInteger i = 0; i < 4; i++)
    {
        CGContextMoveToPoint(context, ox + 0.05 * width, oy + (0.05 + 0.3 * i) * height);
        CGContextAddLineToPoint(context, ox + 0.95 * width, oy + (0.05 + 0.3 * i) * height);
    }
    CGContextSetLineWidth(context, 0.01 * height);
    [[UIColor grayColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat crosssize = 0.1 * MIN(width, height);
    CGContextBeginPath(context);
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            CGFloat cx = ox + (0.05 + 0.3 * x + 0.15) * width;
            CGFloat cy = oy + (0.05 + 0.3 * y + 0.15) * height;
            if ([_gameLogical markAtY:y atX:x] == 1) {
                CGContextMoveToPoint(context, cx - crosssize, cy - crosssize);
                CGContextAddLineToPoint(context, cx + crosssize, cy + crosssize);
                CGContextMoveToPoint(context, cx - crosssize, cy + crosssize);
                CGContextAddLineToPoint(context, cx + crosssize, cy - crosssize);
//                NSLog(@" %f, %f, %f", cx, cy, crosssize);
            }
        }
    }
    CGContextSetLineWidth(context, 0.1 * crosssize);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);

    //draw circle
    CGFloat circlesize = 0.1 * MIN(width, height);
    CGContextBeginPath(context);
    for (NSInteger y = 0; y < 3; y++) {
        for (NSInteger x = 0; x < 3; x++) {
            CGFloat cx = ox + (0.05 + 0.3 * x + 0.15) * width;
            CGFloat cy = oy + (0.05 + 0.3 * y + 0.15) * height;
            if ([_gameLogical markAtY:y atX:x] == 2) {
                CGContextMoveToPoint(context, cx + circlesize, cy);
                CGContextAddArc(context, cx, cy, circlesize, 0, M_PI, NO);
                CGContextAddArc(context, cx, cy, circlesize, M_PI, 0, NO);
//                NSLog(@" %f, %f,  %f,%f    %f",cx,cy,ox,oy,circlesize);

            }
        }
    }
    
    CGContextSetLineWidth(context, 0.1 * circlesize);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

@end
