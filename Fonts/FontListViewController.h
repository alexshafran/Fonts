//
//  FontListViewController.h
//  Fonts
//
//  Created by Alex Shafran on 8/30/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kStyleTypeNone = 0,
    kStyleTypeNormal = 1,
    kStyleTypeBold = 2,
    kStyleTypeItalic = 3,
} StyleType;

typedef enum {
    kSortTypeAlphabetical,
    kSortTypeFamily
} SortType;

@interface FontListViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *fontList;
@property (nonatomic, strong) NSMutableArray *filterResults;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end
