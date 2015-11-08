//
//  option.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-24.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface option : NSObject

@property (nonatomic) BOOL twoPlayers;
@property (copy, nonatomic) NSString *player1Name;
@property (copy, nonatomic) NSString *player2Name;
@property (copy, nonatomic) NSString *aiName;
@property (nonatomic) NSInteger firstMove;

@property (readonly, nonatomic) NSString *pathTwoPlayers;
@property (readonly, nonatomic) NSString *pathPlayer1Name;
@property (readonly, nonatomic) NSString *pathPlayer2Name;
@property (readonly, nonatomic) NSString *pathAiName;
@property (readonly, nonatomic) NSString *pathFirstMove;

- (void) saveDefaults;
- (void) loadDefaults;
- (void) reset;
- (option *)copy;

@end
