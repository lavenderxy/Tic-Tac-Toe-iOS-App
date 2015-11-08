//
//  gameGrid.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameLogic.h"

@protocol gameGridDelegate;

@interface gameGrid : UIView
{
    BOOL _hasInit;
    gameLogic *_gameLogical;
}

@property (weak, nonatomic) id<gameGridDelegate> delegate;
- (void) initGameLogic: (gameLogic *)gameLogic;
- (void) updategrid;

@end

@protocol gameGridDelegate <NSObject>

- (void) delegateGameGridWronglyTouched: (gameGrid *)sender;
- (void) delegateGameGridWrongPlaced: (NSInteger) mark forSender: (gameGrid *)sender;
- (void) delegateGameGridShouldPlace: (NSInteger)mark atY:(NSInteger)y atX: (NSInteger)x forSender: (gameGrid *)sender;

@end
