//
//  gameController.m
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-24.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import "gameController.h"
#import "gamePlayViewController.h"

@interface gameController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *versionSegments;
@property (weak, nonatomic) IBOutlet UIPickerView *firstMovePicker;
@property (weak, nonatomic) IBOutlet UITextField *nameField1;
@property (weak, nonatomic) IBOutlet UITextField *nameField2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@end

@implementation gameController


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isViewLoaded)
    {
        [self.nameField1 resignFirstResponder];
        [self.nameField2 resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)changeVersion:(UISegmentedControl *)sender {
    _forOptions.twoPlayers = (self.versionSegments.selectedSegmentIndex == 1? YES : NO);
}

- (IBAction)editName1:(UITextField *)sender {
    _forOptions.player1Name = self.nameField1.text;
}

- (IBAction)editName2:(UITextField *)sender {
    if (_forOptions.twoPlayers){
        _forOptions.player2Name = self.nameField2.text;
    }
    else{
        _forOptions.aiName = self.nameField2.text;
    }
}

- (IBAction)endName1:(UITextField *)sender {
    [self.nameField1 resignFirstResponder];
}

- (IBAction)endName2:(UITextField *)sender {
    [self.nameField2 resignFirstResponder];
}

- (IBAction)clickReset:(UIButton *)sender {
    [_forOptions reset];
}

- (IBAction)clickPlay:(id)sender{
//    gamePlayViewController *conGame = [[gamePlayViewController alloc] initWithNibName:@"gamePlayViewController" bundle:nil forOptions:_forOptions];
//    conGame.title = @"Tic-Tac-Toe";
//    [self.navigationController pushViewController:conGame animated:YES];
    if (self.delegate != nil) {
        [self.delegate delegategameControllerclickOK:self];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (self.delegate != nil){
        [self.delegate delegategameControllerWillDisappear:self];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![self isViewLoaded]){
        return;
    }
    if ([keyPath isEqualToString:_forOptions.pathTwoPlayers]){
        if (_forOptions.twoPlayers){
            self.versionSegments.selectedSegmentIndex = 1;
            self.nameLabel1.text = @"Player 1";
            self.nameLabel2.text = @"Player 2";
            self.nameField2.text = _forOptions.player2Name;
            [self.firstMovePicker reloadAllComponents];
        }
        else{
            self.versionSegments.selectedSegmentIndex =0;
            self.nameLabel1.text = @"Player ";
            self.nameLabel2.text = @"Computer ";
            self.nameField2.text = _forOptions.aiName;
            [self.firstMovePicker reloadAllComponents];
        }
        
    }
    else if ([keyPath isEqualToString:_forOptions.pathPlayer1Name]){
        self.nameField1.text = _forOptions.player1Name;
    }
    else if ([keyPath isEqualToString:_forOptions.pathPlayer2Name]){
        if (_forOptions.twoPlayers){
            self.nameField2.text = _forOptions.player2Name;
        }
    }
    else if ([keyPath isEqualToString:_forOptions.pathAiName]){
        if (!_forOptions.twoPlayers){
            self.nameField2.text = _forOptions.aiName;
        }
    }
    else if ([keyPath isEqualToString:_forOptions.pathFirstMove]){
        [self.firstMovePicker selectRow:(_forOptions.firstMove == 1 ?1: _forOptions.firstMove == 2? 2:0) inComponent:0 animated:NO];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_forOptions.twoPlayers) {
        return (row == 1? @"Player 1": row == 2? @"Player 2": @"Random");
    }
    else {
        return (row == 1? @"Player": row == 2? @"Computer": @"Random");
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _forOptions.firstMove = (row == 1? 1: row == 2? 2: 0);
}

- (void)doInitWithRefOptions:(option *)options
{
    _forOptions = options;
    [_forOptions loadDefaults];
    [_forOptions addObserver:self forKeyPath:_forOptions.pathTwoPlayers options:0 context:NULL];
    [_forOptions addObserver:self forKeyPath:_forOptions.pathPlayer1Name options:0 context:NULL];
    [_forOptions addObserver:self forKeyPath:_forOptions.pathPlayer2Name options:0 context:NULL];
    [_forOptions addObserver:self forKeyPath:_forOptions.pathAiName options:0 context:NULL];
    [_forOptions addObserver:self forKeyPath:_forOptions.pathFirstMove options:0 context:NULL];
    self.delegate = nil;
}

- (void)dealloc
{
    self.delegate = nil;
    [_forOptions removeObserver:self forKeyPath:_forOptions.pathTwoPlayers];
    [_forOptions removeObserver:self forKeyPath:_forOptions.pathPlayer1Name];
    [_forOptions removeObserver:self forKeyPath:_forOptions.pathPlayer2Name];
    [_forOptions removeObserver:self forKeyPath:_forOptions.pathAiName];
    [_forOptions removeObserver:self forKeyPath:_forOptions.pathFirstMove];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forOptions:(option *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self doInitWithRefOptions:options];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.versionSegments.selectedSegmentIndex = (_forOptions.twoPlayers?1:0);
    self.nameField1.text = _forOptions.player1Name;
    if (_forOptions.twoPlayers){
        self.nameLabel1.text = @"Player 1";
        self.nameLabel2.text = @"Player 2";
        self.nameField2.text = _forOptions.player2Name;
    }
    else {
        self.nameLabel1.text = @"Player";
        self.nameLabel2.text = @"Computer";
        self.nameField2.text = _forOptions.aiName;
    }
    self.firstMovePicker.dataSource = self;
    self.firstMovePicker.delegate = self;
    [self.firstMovePicker selectRow:_forOptions.firstMove == 1? 1:_forOptions.firstMove == 2? 2:0 inComponent:0 animated:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window]==nil){
        self.view = nil;
    }
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
