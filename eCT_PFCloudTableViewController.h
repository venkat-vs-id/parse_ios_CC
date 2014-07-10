/**
 eCT_PFCloudTableViewController.h
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

@interface eCT_PFCloudTableViewController : UITableViewController<UISearchBarDelegate>{

    int  iLimitRows;
    
    BOOL iPagenationEnabled;
    BOOL iShowSearchBar;
    BOOL iPullToRefreshEnabled;
    
    NSString *iLoadMoreString;
    NSString *iSpinningWheelLoadingString;
    NSString *iCloudCodeName;
    NSString *iPrototypeCellName;
    NSString  *iLimitRowsParamStr;
    NSString  *iSkipParamStr;
    NSString  *iSearchParamStr;

    NSDictionary *iCloudCodeParams;
    NSMutableArray *_iArrCloudData;
    
    UISearchBar  *iSearchBar;
    UIImage  *iPlaceholderImage;
    
}

@property(nonatomic) BOOL iPagenationEnabled;
@property(nonatomic) BOOL iShowSearchBar;
@property(nonatomic) BOOL iPullToRefreshEnabled;
@property(nonatomic) int  iLimitRows;
@property(nonatomic,retain) NSString *iLoadMoreString;
@property(nonatomic,retain) NSString *iSpinningWheelLoadingString;
@property(nonatomic,retain) UIImage  *iPlaceholderImage;
@property(nonatomic,retain) NSString *iCloudCodeName;
@property(nonatomic,retain) NSString *iPrototypeCellName;
@property(nonatomic,retain) NSDictionary *iCloudCodeParams;
@property(nonatomic,retain) UISearchBar *iSearchBar;
@property(nonatomic,retain) NSString  *iLimitRowsParamStr;
@property(nonatomic,retain) NSString  *iSkipParamStr;
@property(nonatomic,retain) NSString  *iSearchParamStr;
@property(nonatomic,retain) NSMutableArray *_iArrCloudData;

-(void) customizeSetup;

-(void) fireCloudQuery;
-(void) clearTableData;
-(void) reloadTableData;

-(void) objectsWillLoad;
-(void) objectsDidLoad:(NSError *)error;

-(void) showSpinningWheel;
-(void) hideSpinningWheel;

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                   ParseObject:(PFObject *)object;

/*
-(void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath
     ParseObject:(PFObject *)object;
*/
@end
