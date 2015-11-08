//
//  GameMain.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-23.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "GameMain.h"
#import "gameController.h"
#import "gamePlayViewController.h"


@interface GameMain ()

@end

@implementation GameMain


- (IBAction)clickStart:(UIButton *)sender {
    [self.navigationController pushViewController:_gameCon animated:YES];
}

- (void) delegategameControllerclickOK:(gameController *)sender
{
    [_options saveDefaults];
    _shouldStart = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)delegategameControllerWillDisappear:(gameController *)sender
{
    [_options saveDefaults];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (_shouldStart) {
        gamePlayViewController *conGame = [[gamePlayViewController alloc] initWithNibName:@"gamePlayViewController" bundle:nil forOptions:_options];
        conGame.title = @"Tic-Tac-Toe";
        [self.navigationController pushViewController:conGame animated:YES];
    }
}

- (void) doInit
{
    _options = [[option alloc] init];
    [_options loadDefaults];
    _gameCon = [[gameController alloc] initWithNibName:@"gameController" bundle:nil forOptions:_options];
    _gameCon.title = @"Game";
    _gameCon.delegate = self;
    _shouldStart = NO;
}

- (void) dealloc
{
    _gameCon.delegate = nil;
    _gameCon = nil;
    _options = nil;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self doInit];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
