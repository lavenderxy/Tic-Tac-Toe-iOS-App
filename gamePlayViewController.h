//
//  gamePlayViewController.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "option.h"
#import "gameController.h"
#import "gameGrid.h"
#import "gameLogic.h"

@interface gamePlayViewController : UIViewController <gameGridDelegate, gameControllerDelegate>
{
    gameLogic *_gameLogical;
    gameController *_gameCon;
    option *_options;
    NSString * _tip;
    NSInteger _player1Mark;
    NSInteger _player2Mark;
    NSInteger _firstMove;
    NSInteger _currentMove;
    BOOL _showFinishNow;
    BOOL _showFinish;
    NSTimer *_aiTimer;
    NSInteger _aiMark;
    NSInteger _aiY;
    NSInteger _aiX;
    BOOL _shouldMoveNext;
    BOOL _visible;
    
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forOptions:(option *)options;

@end
