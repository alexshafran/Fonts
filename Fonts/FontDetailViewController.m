//
//  FontDetailViewController.m
//  Fonts
//
//  Created by Alex Shafran on 8/31/12.
//  Copyright (c) 2012 Alex Shafran. All rights reserved.
//

#import "FontDetailViewController.h"
#import "FontDetailView.h"
#import "FontSelectionViewController.h"

@interface FontDetailViewController () {

    FontDetailView *fontView;
    UISegmentedControl *stateControl;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *familyButton;
    UISlider *slider;
    
}

@end

#define kFontPreviewText @"ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890"

@implementation FontDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailBG.png"]];
    [self.view addSubview:backgroundView];
    
    fontView = [[FontDetailView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:fontView];
    
    stateControl = [[UISegmentedControl alloc] initWithItems:@[@"Preview", @"Try"]];
    [stateControl addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    stateControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.navigationItem.titleView = stateControl;
    
    clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearField:)];
    familyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"family.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(familyButtonPressed:)];
    
    [[fontView fontSizeSlider] setMinimumValue:28];
    [[fontView fontSizeSlider] setMaximumValue:100];
    [[fontView fontSizeSlider] setValue:28];
    [[fontView fontSizeSlider] addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[fontView titleLabel] setFont:[UIFont fontWithName:_font size:20]];
    [[fontView titleLabel] setText:_font];
    [[fontView editTextView] setFont:[UIFont fontWithName:_font size:28]];
    
    stateControl.selectedSegmentIndex = 0;
    [self prepareForState:kEditingStatePreview];
}

- (void)stateChanged:(id)sender {
    
    int index = ((UISegmentedControl *)sender).selectedSegmentIndex;
    if (index == 1) {
        [self prepareForState:kEditingStateCustom];
    } else {
        [self prepareForState:kEditingStatePreview];
    }
    
}

- (void)sliderMoved:(id)sender {
    
    int value = round(((UISlider*)sender).value);
    [[fontView editTextView] setFont:[UIFont fontWithName:_font size:value]];
}

- (void)prepareForState:(EditingState)editingState {
    
    if (editingState == kEditingStatePreview) {

        [self.navigationItem setRightBarButtonItem:familyButton animated:YES];
        [[fontView editTextView] resignFirstResponder];
        fontView.editTextView.textAlignment = UITextAlignmentCenter;
        [[fontView editTextView] setText:kFontPreviewText];
        CGSize size = [kFontPreviewText sizeWithFont:[UIFont fontWithName:_font size:28] constrainedToSize:CGSizeMake(fontView.editTextView.frame.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [UIView animateWithDuration:.2 animations:^{
            fontView.titleLabel.frame = CGRectMake(0, -10, self.view.frame.size.width, 44);
            fontView.editTextView.frame = CGRectMake(10, 45, self.view.frame.size.width - 20, size.height + 20);
            fontView.fontSizeSlider.alpha = 1.0f;
        }];
        
    } else {
        
        [self.navigationItem setRightBarButtonItem:clearButton animated:YES];
        [[fontView editTextView] becomeFirstResponder];
        [fontView.editTextView setText:@""];
        fontView.editTextView.textAlignment = UITextAlignmentLeft;
        [UIView animateWithDuration:.2 animations:^{
            fontView.titleLabel.frame = CGRectMake(0, -20, self.view.frame.size.width, 44);
            fontView.editTextView.frame = CGRectMake(10, 25, self.view.frame.size.width - 20, 140);
            fontView.fontSizeSlider.alpha = 0.0f;
        }];
    
    }
}

- (void)clearField:(id)sender {
    
    [[fontView editTextView] setText:@""];
    
}

- (void)familyButtonPressed:(id)sender {
    
    FontSelectionViewController *fontSelectionViewController = [[FontSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    fontSelectionViewController.delegate = self;
    fontSelectionViewController.familyName = [UIFont fontWithName:_font size:0.0f].familyName;
    [self.navigationController pushViewController:fontSelectionViewController animated:YES];
    
}

- (void)fontSelectionViewControllerDidExitWithFontName:(NSString *)font {
    
    _font = font;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
