//
//  orderCart.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-16.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderCart : NSObject

@property(strong,nonatomic) NSString *restaurantName;

//List of ordered items, and the "menuNamesAndPrices" is for the payments page
@property(strong,nonatomic) NSMutableDictionary *orderedItems;
@property (strong,nonatomic) NSMutableDictionary *menuNamesAndPrices;

@property(strong,nonatomic) NSString *userName;
@property(strong,nonatomic) NSString *deliveryAddress;
@property(strong,nonatomic) NSString *apartmentRoomNumber;
@property(strong,nonatomic) NSString *additionalDetails;
@property(strong,nonatomic) NSString *contact;


@end
