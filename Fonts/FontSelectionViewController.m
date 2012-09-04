//
//  FontSelectionViewController.m
//  Fonts
//
//  Created by Alex Shafran on 9/3/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import "FontSelectionViewController.h"

@interface FontSelectionViewController () {
    
    NSArray *fontList;
}

@end

@implementation FontSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _familyName;
    fontList = [UIFont fontNamesForFamilyName:_familyName];

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
    return [fontList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.font = [UIFont fontWithName:[fontList objectAtIndex:indexPath.row] size:17];
    cell.textLabel.text = [fontList objectAtIndex:indexPath.row];
                           
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_delegate respondsToSelector:@selector(fontSelectionViewControllerDidExitWithFontName:)]) {
        [_delegate fontSelectionViewControllerDidExitWithFontName:[fontList objectAtIndex:indexPath.row]];
    }    
}

@end
