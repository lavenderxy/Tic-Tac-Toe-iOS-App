//
//  option.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-24.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "option.h"

@implementation option

- (NSString *) pathTwoPlayers
{
    return @"twoPlayers";
}

- (NSString *) pathPlayer1Name
{
    return @"player1Name";
}

- (NSString *) pathPlayer2Name
{
    return @"player2Name";
}

- (NSString *) pathAiName
{
    return @"aiName";
}

- (NSString *) pathFirstMove
{
    return @"firstMove";
}

- (void)saveDefaults
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:self.twoPlayers forKey:@"twoPlayers"];
    [def setObject:self.player1Name forKey:@"player1Name"];
    [def setObject:self.player2Name forKey:@"player2Name"];
    [def setObject:self.aiName forKey:@"aiName"];
    [def setInteger:self.firstMove forKey:@"firstMove"];
    [def synchronize];
}

- (void)loadDefaults
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    BOOL tempBool;
    NSString *tempString;
    NSInteger tempInt;
    
    tempBool = [def boolForKey:@"twoPlayers"];
    if([def objectForKey:@"twoPlayers"]==nil){
        tempBool = NO;
    }
    self.twoPlayers = tempBool;
    
    tempString = [def stringForKey:@"player1Name"];
    if (tempString == nil){
        tempString = @"Angela";
    }
    self.player1Name = tempString;
    
    tempString = [def stringForKey:@"player2Name"];
    if (tempString == nil){
        tempString = @"Mike";
    }
    self.player2Name = tempString;
    
    tempString = [def stringForKey:@"aiName"];
    if (tempString == nil){
        tempString = @"computer";
    }
    self.aiName = tempString;
    
    tempInt = [def integerForKey:@"firstMove"];
    if ([def objectForKey:@"firstMove"] == nil){
        tempInt = 0;
    }
    self.firstMove = tempInt;
    
}

- (void)reset
{
    self.twoPlayers = NO;
    self.player1Name = @"Angela";
    self.player2Name = @"Mike";
    self.aiName = @"Computer";
    self.firstMove = 0;
}

- (option *)copy
{
    option *options = [[option alloc] init];
    options.twoPlayers = self.twoPlayers;
    options.player1Name = self.player1Name;
    options.player2Name = self.player2Name;
    options.aiName = self.aiName;
    options.firstMove = self.firstMove;
    return options;
}


@end
