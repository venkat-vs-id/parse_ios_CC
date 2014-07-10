//
//  ParseCCTableViewController.m
//  ParseStarterProject
//
//  Created by Venkat.V.S.
//
//

#import "ParseCCTableViewController.h"

@interface ParseCCTableViewController ()

@end

@implementation ParseCCTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) setCloudParams{
    
    if (self.iSearchBar.text) {
        
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@":.,%?*"];
        NSString *newStr =[[self.iSearchBar.text componentsSeparatedByCharactersInSet: doNotWant]
                           componentsJoinedByString: @" "];
        
        self.iCloudCodeParams =@{@"some_default_params": @"param_value", @"searchStr": newStr};
    }else{
        
        //set some default value if u have any
        self.iCloudCodeParams =@{@"some_default_params": @"param_value"};
    }
}

-(void)customizeSetup{
    
    self.iShowSearchBar         = true;
    self.iPagenationEnabled     = false;
    self.iPullToRefreshEnabled  = true;
    
    //limitrows and loadmoreString makes no sense if pagenationenabled is set to false;
    self.iLimitRows                  = 5;
    self.iLoadMoreString             = @"Load More rows..";
    self.iSpinningWheelLoadingString = @"Loading...";
    
    self.iPrototypeCellName = @"cell";
    self.iCloudCodeName     = @"CCTest";
    
    [self setCloudParams];
}

// customize for "cell layout"
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                   ParseObject:(PFObject *)object{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.iPrototypeCellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.iPrototypeCellName];
    }
    
    NSLog(@">>> Object >> %@", object);

    // Configure the cell... customize this to pait your cell.
    cell.textLabel.text = [object objectForKey:@"val"];
    
    
    return cell;
}


// customize for "cell- select" actions
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
     ParseObject:(PFObject *)object{
    
    //override and customize it
    
}

@end
