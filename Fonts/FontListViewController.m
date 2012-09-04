//
//  FontListViewController.m
//  Fonts
//
//  Created by Alex Shafran on 8/30/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import "FontListViewController.h"
#import "FontDetailViewController.h"

@interface FontListViewController () {

    UISearchBar *searchBar;
    UIBarButtonItem * searchButton;
}

@end

@implementation FontListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _fontList = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAllFonts];
    [self loadTableView:self.tableView withSortType:kSortTypeAlphabetical];
    
    UISegmentedControl *styleControl = [[UISegmentedControl alloc] initWithItems:
                                        @[[UIImage imageNamed:@"all.png"],
                                        [UIImage imageNamed:@"regular.png"],
                                        [UIImage imageNamed:@"bold.png"],
                                        [UIImage imageNamed:@"italic.png"]]];
    
    styleControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [styleControl addTarget:self action:@selector(styleControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = styleControl;
    
    searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonPressed:)];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)]; // frame corrects vertical offset error
    searchBar.delegate = self;
    [self.tableView setTableHeaderView:searchBar];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [_searchController setDelegate:self];
    [_searchController setSearchResultsDelegate:self];
    [_searchController setSearchResultsDataSource:self];
    
    self.title = @"Fonts";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)styleControlValueChanged:(id)sender {
    
    int value = ((UISegmentedControl*)sender).selectedSegmentIndex;
    [self loadTableView:self.tableView withStyle:(StyleType)value];
    
}

- (void)searchButtonPressed:(id)sender {
    
    if (self.tableView.contentOffset.y) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:YES];
    }
    
    [searchBar becomeFirstResponder];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y) {
        [self.navigationItem setRightBarButtonItem:searchButton animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)loadTableView:(UITableView*)tableView withStyle:(StyleType)styleType {
    
    if (_filterResults) {
        [_filterResults removeAllObjects];
    } else {
        _filterResults = [NSMutableArray new];
    }
    
    _filterResults = [_fontList mutableCopy];
    NSPredicate *predicate;
    
    switch (styleType) {

        case kStyleTypeNone:
            break;
        case kStyleTypeNormal:
            predicate = [NSPredicate predicateWithFormat:@"(not SELF contains[c] %@) AND (not SELF contains[c] %@)"
                         "AND (not SELF contains[c] %@) AND (not SELF contains[c] %@) AND (not SELF contains[c] %@)",
                         @"bold", @"black", @"heavy", @"italic", @"oblique"];
            break;
        case kStyleTypeBold:
            predicate = [NSPredicate predicateWithFormat:@"(SELF contains[c] %@) OR (SELF contains[c] %@)"
                         "OR (SELF contains[c] %@)",
                         @"bold", @"black", @"heavy"];
            break;
        case kStyleTypeItalic:
            predicate = [NSPredicate predicateWithFormat:@"(SELF contains[c] %@) OR (SELF contains[c] %@)",
                         @"italic", @"oblique"];
            break;
        default:
            break;
    }
    
    if (predicate)
        [_filterResults filterUsingPredicate:predicate];
    
    [self loadTableView:self.tableView withSortType:kSortTypeAlphabetical];
    
}

- (void)loadTableView:(UITableView*)tableView withSortType:(SortType)sortType {

    [_filterResults sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [tableView reloadData];
}

- (void)filterResultsWithSearchString:(NSString*)searchText {
    
    _filterResults = [_fontList mutableCopy];
    [_filterResults filterUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains[c] %@) OR (SELF contains[c] %@)",
                                          searchText, [searchText stringByReplacingOccurrencesOfString:@" " withString:@""]]];
}

- (NSMutableArray*)loadAllFonts {

    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *font in [UIFont fontNamesForFamilyName:familyName]) {
            [_fontList addObject:font];
        }
    }
    
    _filterResults = [_fontList mutableCopy];
    
    return _filterResults;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filterResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_filterResults objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:[_filterResults objectAtIndex:indexPath.row] size:17];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FontDetailViewController *fontViewController = [[FontDetailViewController alloc] initWithNibName:nil bundle:nil];
    [fontViewController setFont:[_filterResults objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:fontViewController animated:YES];
}

#pragma mark - Search Display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterResultsWithSearchString:searchString];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _filterResults = [_fontList mutableCopy];
    [_filterResults sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

@end
