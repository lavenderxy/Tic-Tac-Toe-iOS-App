//
//  gameController.h
//  yanLab3
//
//  Created by 闫 欣宇 on 15-9-24.
//  Copyright (c) 2015年 XinyuYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "option.h"

@protocol gameControllerDelegate;

@interface gameController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    option *_forOptions;
    
}

@property (weak, nonatomic) id<gameControllerDelegate> delegate;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forOptions:(option *)options;

@end

@protocol gameControllerDelegate <NSObject>

- (void) delegategameControllerclickOK: (gameController *)sender;
- (void) delegategameControllerWillDisappear: (gameController *)sender;

@end