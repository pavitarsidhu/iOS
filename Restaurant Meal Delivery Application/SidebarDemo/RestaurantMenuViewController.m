//
//  RestaurantMenuViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-13.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "RestaurantMenuViewController.h"
#import "MenuViewCell.h"
#import <dispatch/dispatch.h>
#import "OrderDetailsViewController.h"

@interface RestaurantMenuViewController ()

@end

@implementation RestaurantMenuViewController

-(void)viewDidAppear:(BOOL)animated{
    [_menuTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Give continue button border
    _continueButton.layer.borderWidth = .5f;
    _continueButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    //Grab specific menu for restaurant
    [self fetchRestaurantMenu];
    
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_foodItemNames count];;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuViewCell *cell = (MenuViewCell*) [_menuTable dequeueReusableCellWithIdentifier:@"menuItem" forIndexPath:indexPath];
    
    cell.addButton.tag = indexPath.row;
    cell.removeButton.tag = indexPath.row;
    cell.delegate = self;
    
    if(_flag == true) {
        cell.cart = _cart;
        cell.itemName.text = _foodItemNames[indexPath.row];
        cell.itemPrice.text = [NSString stringWithFormat:@"$%@",[_cart.menuNamesAndPrices objectForKey:cell.itemName.text]];
        
        if(_cart.orderedItems[_foodItemNames[indexPath.row]]) {
            NSString *temp = _foodItemNames[indexPath.row];
            cell.specificItemCount.text = [_cart.orderedItems objectForKey:temp];
        } else {
            cell.specificItemCount.text = @"0";
        }
    }
    
    //Makes sure cells aren't highlighted if user taps them
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    OrderDetailsViewController *temp = segue.destinationViewController;
    temp.cart = _cart;
}

- (IBAction)checkoutPressed:(id)sender {
    if([_cart.orderedItems count] == 0) {
        
        //Create/setup alert controller
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Cart" message:@"Please select atleast one item." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
    [self performSegueWithIdentifier:@"orderCheckout" sender:self];
        
    }
}

-(void)fetchRestaurantMenu {

    NSString *restaurantNameFormatted = [self URLEncodeStringFromString:_restaurantName];
  
    
    NSString *categoryNameFormatted = [self URLEncodeStringFromString:_category];

    
    NSString *url = [NSString stringWithFormat:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/menusFromCategories.php?name=%@&category=%@",restaurantNameFormatted,categoryNameFormatted];
    NSURL *URL = [NSURL URLWithString:url];
        
    NSURLSessionDataTask *downloadMenu = [[NSURLSession sharedSession]dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        /* The blocks of code below fetch the JSON formatted menu data from PHP page 
         and then populate an array with the key values of the dictionary. The dictionary
         contains keys as food item names and values as prices for each indvidivual meal. */
        NSError *someError;
        
        NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&someError];
        
        NSMutableDictionary *menuNamesAndPrices = temp[0];
        
        _foodItemNames = [menuNamesAndPrices allKeys];
        
        /* Here we are updating the menuNamesAndPrices dictionary for every menu
         that the user views. That isn't necessarily needed, but it ensures every items
         price that the user saw will be added to this dictionary. */
        for(int i = 0; i < [_foodItemNames count]; i++) {
            _cart.menuNamesAndPrices[_foodItemNames[i]] = [menuNamesAndPrices objectForKey:_foodItemNames[i]];
        }
        
        /*You CANNOT call any UIKit methods in secondary threads, so because of that
         we use GSD to execute "reloadData" in main thread. */
        dispatch_async(dispatch_get_main_queue(), ^{
            [_menuTable reloadData];
        });
        
        //Set flag to tell TableView methods to use new dictionary/array properly
        _flag = true;

    }];
    
    [downloadMenu resume];
}

/* Each cell is declared a delegate of the MenuViewCell protocol
 because it ensures we add/remove the proper items from our 
 array as the users selection & removal process continues. */
-(void)removeItem:(int)tag count:(int)itemNumber{
    NSString *key = _foodItemNames[tag];
    if((_cart.orderedItems[key] != nil) && itemNumber == 0) {
        [_cart.orderedItems removeObjectForKey:_foodItemNames[tag]];
    } else if (_cart.orderedItems[key] != nil) {
        NSString *key = [NSString stringWithFormat:@"%d",itemNumber];
        [_cart.orderedItems setObject:key forKey:_foodItemNames[tag]];
    } else {
        return;
    }
}
-(void)addItem:(int)tag count:(int)itemNumber {
    NSString *temp = [NSString stringWithFormat:@"%d",itemNumber];
    [_cart.orderedItems setObject:temp forKey:_foodItemNames[tag]];

}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%*()+'\";:,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@end
