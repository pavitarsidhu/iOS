//
//  MenuViewCell.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-13.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderCart.h"

@protocol MenuViewCellProtocol <NSObject>
-(void)removeItem:(int)tag count:(int)itemNumber;
-(void)addItem:(int)tag count:(int)itemNumber;
@end

@interface MenuViewCell : UITableViewCell

@property(nonatomic,weak)id<MenuViewCellProtocol> delegate;

@property (weak, nonatomic) orderCart *cart;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *specificItemCount;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

- (IBAction)incrementItem:(id)sender;
- (IBAction)decrementItem:(id)sender;
@end
