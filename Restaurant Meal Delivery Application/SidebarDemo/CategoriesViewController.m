//
//  CategoriesViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-27.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "CategoriesViewController.h"
#import <dispatch/dispatch.h>
#import "RestaurantMenuViewController.h"
#import "OrderDetailsViewController.h"


@interface CategoriesViewController ()

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Give continue button border
    _continueButton.layer.borderWidth = .5f;
    _continueButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self fetchMenuCategories];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categories count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryTitle" forIndexPath:indexPath];
    
    if(_flag == true) {
        cell.textLabel.text = _categories[indexPath.row];
    } else {
    return cell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCategory = _categories[indexPath.row];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"specificMenu" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController class] == [RestaurantMenuViewController class]) {
        RestaurantMenuViewController *menuViewController = segue.destinationViewController;
        
        menuViewController.cart = _cart;
        menuViewController.restaurantName = _restaurantName;
        menuViewController.category = _selectedCategory;
    } else {
        OrderDetailsViewController *temp = segue.destinationViewController;
        temp.cart = _cart;
    }
    
}

- (IBAction)continueButtonPressed:(id)sender {
    if([_cart.orderedItems count] == 0) {
        
        //Create/setup alert controller
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Cart" message:@"Please select atleast one item." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        [self performSegueWithIdentifier:@"orderDetails2" sender:self];
        
    }
}

-(void)fetchMenuCategories {
    NSString *formatted = [self URLEncodeStringFromString:_restaurantName];
    
    NSString *url = [NSString stringWithFormat:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/categories.php?name=%@",formatted];
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask *downloadMenu = [[NSURLSession sharedSession]dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        /* The blocks of code below fetch the JSON formatted menu data from PHP page
         and then populate an array with the key values of the dictionary. The dictionary
         contains keys as food item names and values as prices for each indvidivual meal. */
        NSError *someError;
        _categories = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&someError];
        
        //Set flag to tell TableView methods to use the array properly
        _flag = true;
        
        
        /*You CANNOT call any UIKit methods in secondary threads, so because of that
         we use GSD to execute "reloadData" in main thread. */
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        
    }];
    
    [downloadMenu resume];
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%*()+'\";:,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}
@end
