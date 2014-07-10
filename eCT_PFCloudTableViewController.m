/**
 eCT_PFCloudTableViewController.m
 Created by Venkat.V.S on 31/10/13.
 Copyright (c) 2009 www.eCatalyst-Tech.com. All rights reserved.
 Contact:support@ecatalyst-tech.com
 
 1.0 | 01-Oct-2013 | Created

 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THESE PROGRAMS (CODE or SOFTWARE or DOCUMENTATION) SHARED BY ME OR www.eCatalyst-Tech.com
 ARE FURNISHED "AS IS". THESE PROGRAMS ARE NOT THROUGHLY TESTED UNDER ALL CONDITIONS. I, THEREFORE
 CANNOT GAURANTEE OR IMPY RELIABILITY, SERVICEABILITY OR THE FUNCTION O THESE PROGRAMS.I MAKE NO
 WARRANTY, EXPRESS OR IMPLIED, AS TO THE USEFULNESS OF THESE PROGRAMS FOR ANY PURPOSE. I ASSUME NO
 RESPONSIBILITY FOR THE USE OF THESE PROGRAMS; OR TO PROVIDE TECHNICAL SUPPORT TO USERS.
 **/

#import <Parse/Parse.h>
#import "eCT_PFCloudTableViewController.h"
#import "MBProgressHUD.h"

@interface eCT_PFCloudTableViewController(){
    MBProgressHUD *_iMainActivityIndicator;

    BOOL _iAllRowFetched;
}
@property(nonatomic,retain) MBProgressHUD *_iMainActivityIndicator;
@property(nonatomic)BOOL _iAllRowFetched;
@end

@implementation eCT_PFCloudTableViewController
@synthesize iPagenationEnabled;
@synthesize iPullToRefreshEnabled;
@synthesize iShowSearchBar;
@synthesize iLimitRows;
@synthesize iLoadMoreString;
@synthesize iPlaceholderImage;
@synthesize iSpinningWheelLoadingString;
@synthesize iPrototypeCellName;
@synthesize iCloudCodeName;
@synthesize iCloudCodeParams;
@synthesize iSearchBar;
@synthesize _iMainActivityIndicator;
@synthesize _iArrCloudData;
@synthesize iLimitRowsParamStr,iSearchParamStr,iSkipParamStr;
@synthesize _iAllRowFetched;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureFromSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (self.iPagenationEnabled) {
        
        if ( !(self._iAllRowFetched) &&
             self.iPagenationEnabled &&
             (self._iArrCloudData.count > 0 ) &&
             (self._iArrCloudData.count % self.iLimitRows ) == 0) {
            
            return [self._iArrCloudData count] + 1;
        }
    }
    //NSLog(@">>%i", [self._iArrCloudData count]);
    return [self._iArrCloudData count];
}

#pragma mark - Table view data Deletegate
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
     [self hideKeyboard];

     //NSLog(@">>inside >> %i, %i, %i", self.iPagenationEnabled, indexPath.row, self._iArrCloudData.count);
     
     if (self.iPagenationEnabled && (indexPath.row == self._iArrCloudData.count) ) { //"load more"cell
         
         NSString *CellIdentifier = self.iPrototypeCellName;
         
         UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         if (cell == nil) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         cell.textLabel.text = self.iLoadMoreString;

         cell.userInteractionEnabled = YES;
         cell.selectionStyle = UITableViewCellSelectionStyleBlue;
         return cell;
     }
     PFObject *o = [self._iArrCloudData objectAtIndex:indexPath.row];
     // Configure the cell...
     return [self tableView:self.tableView cellForRowAtIndexPath:indexPath ParseObject:o];
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self hideKeyboard];
    if ( self.iPagenationEnabled &&
         indexPath.row == self._iArrCloudData.count) { // this is the "Read more rows"cell
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"";

        [self fireCloudQuery];
        return;
    }
    PFObject *o = [self._iArrCloudData objectAtIndex:indexPath.row];
    // this calls the child
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath ParseObject:o];
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self hideKeyboard];
    [self reloadTableData];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}

#pragma mark - Navigation for story board-based application
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma local Methods - dont override this
-(void)defaultSetup{
    
    self.iShowSearchBar = false;
    self.iPagenationEnabled = true;
    self._iAllRowFetched = false;
    self.iPullToRefreshEnabled = true;
    
    //limitrows and loadmoreString makes no sense if pagenationenabled is set to false;
    self.iLimitRows = 5;
    self.iLoadMoreString = @"Load More rows";
    self.iSpinningWheelLoadingString = @"Loading...";
    
    self.iLimitRowsParamStr = @"limit";
    self.iSearchParamStr = @"searchStr";
    self.iSkipParamStr = @"skip";
    
    self.tableView.allowsSelection = YES;
}

-(void) configureFromSetup{
    
    //-Setup the configuration
    [self defaultSetup];
    [self customizeSetup];

    if (self.tableView.style == UITableViewStyleGrouped) {
        NSLog(@"Warning: At this point this code supports only SinglePlain Style. Please change sytle to 'Plain'.");
    }
    
    if (self.iShowSearchBar) {
        self.iSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
        self.iSearchBar.delegate = self;
        [self.iSearchBar sizeToFit];
        self.tableView.tableHeaderView = self.iSearchBar;
    }
    
    if (self.iPullToRefreshEnabled) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(pull2Refresh:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    }
    
    self._iMainActivityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    self._iMainActivityIndicator.labelText = self.iSpinningWheelLoadingString;
    [self.view addSubview:self._iMainActivityIndicator];
    
    [self reloadTableData];
}


#pragma local Methods - dont have to override
-(void)fireCloudQuery{

    if (![PFUser currentUser]) {
        NSLog(@"Parse User has not logged in  %@", [PFUser currentUser].username);
        return;
    }
    [self objectsWillLoad];

    NSMutableDictionary *tmpD = [[NSMutableDictionary alloc] init];
    tmpD = [self.iCloudCodeParams mutableCopy];
    
    if (self.iPagenationEnabled) {
    
        [tmpD setValue:[NSString stringWithFormat:@"%i", self.iLimitRows] forKey:self.iLimitRowsParamStr];
        [tmpD setValue:[NSString stringWithFormat:@"%i", (int)self._iArrCloudData.count] forKey:self.iSkipParamStr];
        //NSLog(@" cloud params >>>> %@", self.iCloudCodeParams);
    }
    [tmpD setValue:self.iSearchBar.text  forKey:self.iSearchParamStr];
    self.iCloudCodeParams =nil;
    self.iCloudCodeParams = [tmpD copy];
    tmpD = nil;
    
    //NSLog(@"calls the CC %@ , %@", self.iCloudCodeName, self.iCloudCodeParams);
    [PFCloud callFunctionInBackground:self.iCloudCodeName
                       withParameters:self.iCloudCodeParams
                                block:^(NSArray *arrResult, NSError *error) {

          //NSLog(@"result the CC %@ , %@", self.iCloudCodeName, arrResult);
          if (!error){
              
              if(!self._iArrCloudData){
                  self._iArrCloudData = [[NSMutableArray alloc] init];
              }
              
              if (arrResult.count>0) {

                  [self._iArrCloudData addObjectsFromArray:arrResult];
              }else{
                  
                  self._iAllRowFetched = true;
              }
              [self.tableView reloadData];
              
              [self objectsDidLoad:nil];
          }else{
              [self objectsDidLoad:error];
          }
    }];
}

-(void) clearTableData{
    self._iArrCloudData = nil;
    self._iAllRowFetched =false;
    [self.tableView reloadData];
}

-(void) reloadTableData{

    [self clearTableData];
    [self fireCloudQuery];
    [self.tableView reloadData];
}

- (void)pull2Refresh:(UIRefreshControl *)refreshControl {
    [self reloadTableData];
    [refreshControl endRefreshing];
}

-(void)objectsWillLoad{
    [self showSpinningWheel];
}

-(void) objectsDidLoad:(NSError *)error{
    [self hideSpinningWheel];
}

-(void)hideKeyboard{
    [self.iSearchBar resignFirstResponder];
}

-(void) showSpinningWheel;{
    [self._iMainActivityIndicator show:YES];
}

-(void) hideSpinningWheel{
    [self._iMainActivityIndicator hide:YES];
}

#pragma local Methods - override this and customize it.

-(void)customizeSetup{    

    //Overide and customize it
    /*
     self.iShowSearchBar = false;
     self.iPagenationEnabled = true;
     self.iPullToRefreshEnabled = true;
     
     //limitrows and loadmoreString makes no sense if pagenationenabled is set to false;
     self.iLimitRows = 5;
     self.iLoadMoreString = @"Load More rows";
     self.iSpinningWheelLoadingString = @"Loading";
     */
    
    self.iCloudCodeName   =@"";
    self.iCloudCodeParams =@{@"param_name1":@"param_value1", @"param_name2": @"param_value2"};
}


// customize for "cell layout" 
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                      ParseObject:(PFObject *)object{
   
    UITableViewCell *cDummy;
    //Overide and customize it
    
    return cDummy;
}

// customize for "cell- select" actions
-(void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
     ParseObject:(PFObject *)object{
    
    //override and customize it
    
}

@end
