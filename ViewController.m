//
//  ViewController.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-23.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "ViewController.h"
#import "GameMain.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
    [self.view addSubview:_navigationCon.view];
}

-(void)doInit
{
    if(!_doInitiate){
        _doInitiate = YES;
        _navigationCon = [[UINavigationController alloc] init];
        _navigationCon.navigationBar.translucent = NO;
        GameMain *mainCon = [[GameMain alloc]initWithNibName:@"GameMain" bundle:nil];
        mainCon.title = @"Home";
        [_navigationCon pushViewController:mainCon animated:NO];
    }
}

-(void)dealloc
{
    _navigationCon = nil;
}

-(id)init
{
    self = [super init];
    if(self){
        [self doInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
