//
//  DiceDataController.m
//  DiceRoll
//
//  Created by Pavitar Sidhu on 2015-04-25.
//  Copyright (c) 2015 Vimzy App Productions Inc. All rights reserved.
//

#import "DiceDataController.h"

@implementation DiceDataController

-(int) getDieNumber {
    
    return (arc4random() % 6) + 1;
    
}

@end
