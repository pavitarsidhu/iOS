//
//  MenuViewCell.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-13.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "MenuViewCell.h"


@implementation MenuViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)incrementItem:(id)sender {
    int count = 0;
    
    if(_cart.orderedItems[_itemName.text]) {
        NSString *key = _itemName.text;
        NSString *temp = [_cart.orderedItems objectForKey:key];
        
        count = (int)[temp integerValue];
        count++;
    } else {
        count++;
    }
    
    //int count = (int)[self.specificItemCount.text integerValue];
    //count++;
    
    self.specificItemCount.text = [NSString stringWithFormat:@"%i",count];
    
    //Update the user's cart appropriately
    if(self.delegate) {
        [self.delegate addItem:(int)_addButton.tag count:(int)[self.specificItemCount.text integerValue]];
    }
    NSLog(@"%@",_cart.orderedItems);

}

- (IBAction)decrementItem:(id)sender {
    
    int count = 0;
    
    if(_cart.orderedItems[_itemName.text]) {
        NSString *key = _itemName.text;
        NSString *temp = [_cart.orderedItems objectForKey:key];
        
        count = (int)[temp integerValue];
        count--;
    } else {
        count = 0;
    }
    
    
    //int count = (int)[self.specificItemCount.text integerValue];
    
    //We cannot have a negative number of items
    if(count == 0) {
        self.specificItemCount.text = [NSString stringWithFormat:@"%i",count];
        if(self.delegate) {
            [self.delegate removeItem:(int)_removeButton.tag count:(int)[self.specificItemCount.text integerValue]];
        }
    //Decrement item number counter and remove form NSDictionary
    } else {
        //count--;
        self.specificItemCount.text = [NSString stringWithFormat:@"%i",count];

        if(self.delegate) {
            [self.delegate removeItem:(int)_removeButton.tag count:(int)[self.specificItemCount.text integerValue]];
        }
    }
    
    NSLog(@"%@",_cart.orderedItems);
}
@end
