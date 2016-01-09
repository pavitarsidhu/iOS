//
//  ViewController.h
//  DiceRoll
//
//  Created by Pavitar Sidhu on 2015-04-25.
//  Copyright (c) 2015 Vimzy App Productions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DieView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *sumLabel;

@property (strong, nonatomic) IBOutlet UIButton *rollButton;

@property (weak, nonatomic) IBOutlet UIImageView *dieView1;

@property (weak, nonatomic) IBOutlet UIImageView *dieView2;

- (IBAction)rollDiceClicked:(id)sender;

-(int) getDieNumber;

@end

