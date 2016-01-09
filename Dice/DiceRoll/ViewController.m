//
//  ViewController.m
//  DiceRoll
//
//  Created by Pavitar Sidhu on 2015-04-25.
//  Copyright (c) 2015 Vimzy App Productions Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"felt"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollDiceClicked:(id)sender {
    int diceNumber = [self getDieNumber];
    NSString *fileName = [NSString stringWithFormat: @"dice%i",diceNumber];
    
    self.dieView1.image = [UIImage imageNamed:fileName];
    
    diceNumber = [self getDieNumber];
    fileName = [NSString stringWithFormat:@"dice%i",diceNumber];
    self.dieView2.image = [UIImage imageNamed:fileName];
}


-(int) getDieNumber {
    
    return (arc4random() % 6) + 1;
    
}
@end
