//
//  gamePlayViewController.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-25.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "gamePlayViewController.h"

@interface gamePlayViewController ()

//@property (weak, nonatomic) IBOutlet gameGrid *gameGrid;
@property (weak, nonatomic) IBOutlet gameGrid *gameG;

@property (weak, nonatomic) IBOutlet UIButton *gameTip;

@property (weak, nonatomic) IBOutlet UILabel *player1Label;

@property (weak, nonatomic) IBOutlet UILabel *player2Label;

@property (weak, nonatomic) IBOutlet UIView *finishView;

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

@end

@implementation gamePlayViewController

- (void) updateTip
{
    if (![self isViewLoaded]) {
        return;
    }
    if ([_tip isEqualToString:@""]) {
        [self.gameTip setTitle:@"" forState:UIControlStateNormal];
        self.gameTip.hidden = YES;
    }
    else{
        [self.gameTip setTitle:_tip forState:UIControlStateNormal];
        self.gameTip.hidden = NO;
    }
}

- (void) updatePlayerLabel
{
//    if (![self isViewLoaded]) {
//        return;
//    }
    NSString *textForm[3] = {@"",@"X",@"O"};
    NSString *player1 = _options.player1Name;
    self.player1Label.text = [NSString stringWithFormat:@"%@ '%@'",player1,textForm[_player1Mark]];
    NSString *player2 = (_options.twoPlayers ? _options.player2Name : _options.aiName);
    self.player2Label.text = [NSString stringWithFormat:@"%@ '%@'",player2,textForm[_player2Mark]];
}

- (void)updatePlayerColor
{
    if (![self isViewLoaded]) {
        return;
    }
    if (_currentMove==1) {
        _player1Label.textColor = [UIColor blackColor];
        _player1Label.backgroundColor = [UIColor lightGrayColor];
        _player2Label.textColor = [UIColor lightGrayColor];
        _player2Label.backgroundColor = [UIColor clearColor];
    }
    else if (_currentMove==2){
        _player1Label.textColor = [UIColor lightGrayColor];
        _player1Label.backgroundColor = [UIColor clearColor];
        _player2Label.textColor = [UIColor blackColor];
        _player2Label.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        _player1Label.textColor = [UIColor lightGrayColor];
        _player1Label.backgroundColor = [UIColor clearColor];
        _player2Label.textColor = [UIColor lightGrayColor];
        _player2Label.backgroundColor = [UIColor clearColor];
    }

}

-(void)updateGrid
{
    if (![self isViewLoaded]) {
        return;
    }
    [self.gameG updategrid];
}

- (void)replaceConstraintsOfPriority:(UILayoutPriority)oldPriority withPriority:(UILayoutPriority)newPriority
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         if (fabs(constraint.priority - oldPriority) < 0.05) {
             constraint.priority = newPriority;
         }
     }];
}



-(void)updateFinishView: (BOOL)animate
{
    if (![self isViewLoaded]) {
        return;
    }
    if (_showFinishNow) {
        if (_gameLogical.winner == _player1Mark) {
            NSString *player1 = _options.player1Name;
            self.winnerLabel.text = [NSString stringWithFormat:@"%@  Win!",player1];
        }
        else if (_gameLogical.winner == _player2Mark) {
            NSString *player2 = (_options.twoPlayers? _options.player2Name: _options.aiName);
            self.winnerLabel.text = [NSString stringWithFormat:@"%@  Win!",player2];
        }
        else {
            self.winnerLabel.text = @"No Win!Oops!";
        }
        
        // do show
        [self replaceConstraintsOfPriority:989.0 withPriority:189.0];
        [self replaceConstraintsOfPriority:175.0 withPriority:975.0];

        if (animate && !_showFinish) {
            _showFinish = YES;
            [UIView animateWithDuration:0.2 animations:^
             {
                 [self.view layoutIfNeeded];
             }];
        }
        else {
            _showFinish = YES;
            [self.view layoutIfNeeded];
        }
    }
    else {
        [self replaceConstraintsOfPriority:189.0 withPriority:989.0];
        [self replaceConstraintsOfPriority:975.0 withPriority:175.0];
        if (animate && _showFinish) {
            _showFinish = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
        else {
            _showFinish = NO;
            [self.view layoutIfNeeded];
        }
    }

}

- (IBAction)clickTipButton:(UIButton *)sender {
    _tip = @"";
    [self updateTip];
}


- (IBAction)clickYesButton:(UIButton *)sender {
    [self.navigationController pushViewController:_gameCon animated:YES];
}

- (IBAction)clickNoButton:(UIButton *)sender {
    _showFinish = NO;
    [self updateFinishView:YES];
}

- (void)delegategameControllerclickOK:(gameController *)sender
{
    [_options saveDefaults];
    [self startNewGame];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) delegategameControllerWillDisappear:(gameController *)sender
{
    [_options saveDefaults];
}

- (void)delegateGameGridWronglyTouched:(gameGrid *)sender
{
    if ([_gameLogical isGameEnd]) {
        _showFinishNow = YES;
        [self updateFinishView:YES];
    }
    else{
        _tip = @"Tip: wait for your move";
        [self updateTip];
    }
}

- (void)delegateGameGridWrongPlaced:(NSInteger)mark forSender:(gameGrid *)sender
{
    _tip = @"Tip: move to an empty grid";
    [self updateTip];
}

- (void) delegateGameGridShouldPlace:(NSInteger)mark atY:(NSInteger)y atX:(NSInteger)x forSender:(gameGrid *)sender
{
    _tip = @"";
    [self updateTip];
    [self placeMark:mark atY:y atX:x];
}

- (void)aiTimerFired:(NSTimer *)timer
{
    if (_aiTimer != nil) {
        [_aiTimer invalidate];
        _aiTimer = nil;
    }
    [self placeMark:_aiMark atY:_aiY atX:_aiX];
}


- (void)placeMark:(NSInteger)mark atY:(NSInteger)y atX:(NSInteger)x
// performs a move; it can be a player move or an AI move
{
    // tell the game logic to add a mark
    [_gameLogical placeMark:mark atY:y atX:x];
    [self updateGrid];
    // find out who will move next or who has won
    _shouldMoveNext = YES;
    [self moveNextWhenVisible];
}


- (void)moveNext
// update currentMove and prepare for the next move
{
    if ([_gameLogical isGameEnd]) {
        _showFinishNow = YES;
        [self updateFinishView:YES];
        
        _currentMove = 0;
        [self updatePlayerColor];
        
        _gameLogical.currentUserMark = 0;
        return;
    }
    
    _currentMove = (_currentMove == 1? 2: _currentMove == 2? 1: _firstMove);
    [self updatePlayerColor];
    
    if (_currentMove == 1) {
        // player 1 should move
        // allow player1's mark to be placed on the grid
        _gameLogical.currentUserMark = _player1Mark;
    }
    else {
        // player 2 should move
        if (_options.twoPlayers) {
            // allow player2's mark to be placed on the grid
            _gameLogical.currentUserMark = _player2Mark;
        }
        else {
            // it's AI's turn
            _gameLogical.currentUserMark = 0;
            NSInteger x;
            NSInteger y;
            NSInteger t;
            if (![_gameLogical calaiMark:_player2Mark outputY:&y outputX:&x outputType:&t]){
                return;
            }
            if (_aiTimer != nil) {
                [_aiTimer invalidate];
                _aiTimer = nil;
            }
            _aiMark = _player2Mark;
            _aiY = y;
            _aiX = x;
            double thinkingtime = 0.0;
            if (t == 3) {
                // center (first or second move)
                thinkingtime = 0.5 + 0.05 * arc4random_uniform(4);
            }
            else if (t == 1) {
                // winning move
                thinkingtime = 0.1 + 0.05 * arc4random_uniform(4);
            }
            else if (_gameLogical.numPlacedMarks == 8) {
                // last move
                thinkingtime = 0.2 + 0.05 * arc4random_uniform(4);
            }
            else if (t == 2) {
                // blocking move
                thinkingtime = 0.3 + 0.05 * arc4random_uniform(4);
            }
            else {
                thinkingtime = 1.0 + 0.05 * arc4random_uniform(4);
            }
            _aiTimer = [NSTimer scheduledTimerWithTimeInterval:thinkingtime target:self selector:@selector(aiTimerFired:) userInfo:nil repeats:NO];
        }
    }
}


- (void)moveNextWhenVisible
// call this when |_shouldDoNextMove| or |_visible| has changed
{
    if (_shouldMoveNext && _visible) {
        _shouldMoveNext = NO;
        [self moveNext];
    }
}

- (void)startNewGame
{
    if (_aiTimer != nil) {
        [_aiTimer invalidate];
        _aiTimer = nil;
    }
    
    _tip = @"";
    [self updateTip];
    
    [_gameLogical clear];
    [self updateGrid];
    
    if (arc4random_uniform(2) == 0) {
        _player1Mark = 1;
        _player2Mark = 2;
    }
    else {
        _player1Mark = 2;
        _player2Mark = 1;
    }
    [self updatePlayerLabel];
    
    if (_options.firstMove == 0) {
        if (arc4random_uniform(2) == 0) {
            _firstMove = 1;
        }
        else {
            _firstMove = 2;
        }
    }
    else {
        _firstMove = _options.firstMove;
    }
    _currentMove = 0;
    [self updatePlayerColor];
    
    _shouldMoveNext = YES;
    [self moveNextWhenVisible];
    
    _showFinishNow = NO;
    [self updateFinishView:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    _visible = false;
    [self moveNextWhenVisible];
}

- (void)viewDidAppear:(BOOL)animated
{
    _visible = true;
    [self moveNextWhenVisible];
}

- (void)doInitWithOptions:(option *)options
{
    _options = options;
    _gameLogical = [[gameLogic alloc] init];
    _tip = @"";
    _player1Mark = 1;
    _player2Mark = 2;
    _firstMove = 1;
    _currentMove = 0;
    _showFinishNow = NO;
    _showFinish = NO;
    _aiTimer = nil;
    _aiMark = 1;
    _aiY = 0;
    _aiX = 0;
    _shouldMoveNext = NO;
    _visible = NO;
    _gameCon = [[gameController alloc] initWithNibName:@"gameController" bundle:nil forOptions:options];
    _gameCon.title = @"Game";
    _gameCon.delegate = self;
    [self startNewGame];
}

- (void)dealloc
{
    if (_aiTimer != nil) {
        [_aiTimer invalidate];
        _aiTimer = nil;
    }
    if ([self isViewLoaded]) {
        self.gameG.delegate = nil;
    }
    _gameCon.delegate = nil;
    _gameCon = nil;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forOptions:(option *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self doInitWithOptions:options];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [self updateGrid];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.gameG initGameLogic:_gameLogical];
    self.gameG.delegate = self;
    
    [self updateTip];
    [self updatePlayerLabel];
    [self updatePlayerColor];
    _showFinish = YES;
    [self updateFinishView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
