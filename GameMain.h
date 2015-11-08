//
//  GameMain.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-23.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameController.h"
#import "option.h"

@interface GameMain : UIViewController <gameControllerDelegate>
{
    gameController *_gameCon;
    BOOL _shouldStart;
    option *_options;
}
@end
