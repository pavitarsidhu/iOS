//
//  DieView.m
//  DiceRoll
//
//  Created by Pavitar Sidhu on 2015-04-25.
//  Copyright (c) 2015 Vimzy App Productions Inc. All rights reserved.
//

#import "DieView.h"
#import "DiceDataController.h"

@implementation DieView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.dieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    
        [self addSubview:self.dieImageView];
    
    }
    return self;
    
}

-(void)showDieNumber:(int)num {
    NSString *fileName = [NSString stringWithFormat: @"dice%i",num];

    self.dieImageView.image = [UIImage imageNamed:fileName];
}

@end
