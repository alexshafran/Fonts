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

#define kFontPreviewTextAlphaNumeric @"ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890"
#define kFontPreviewTextQuickFox @"The quick brown fox jumps over the lazy dog."
#define kFontPreviewTextNumeric @"123\n456\n7890"
#define kFontPreviewTextSymbol @"[ ] { } # & ^ * + = _ \\ / | ~ < > . , ? ! ' @ $ % ( ) : ;"

#define isFourInchScreen self.view.frame.size.height > 480
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
    [[fontView fontSizeSlider] addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    [[fontView previewTextControl] setSelectedSegmentIndex:0];
    [[fontView previewTextControl] addTarget:self action:@selector(changePreviewText:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[fontView fontSizeSlider] setValue:28 animated:YES];
    [[fontView titleLabel] setFont:[UIFont fontWithName:_font size:20]];
    [[fontView titleLabel] setText:_font];
    
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

- (void)changePreviewText:(id)sender {
    
    int value = fontView.previewTextControl.selectedSegmentIndex;

    NSString *placeholderText;
    int fontSize;
    UILineBreakMode lineBreakMode = UILineBreakModeCharacterWrap;
    
    switch (value) {
        case 0:
            placeholderText = kFontPreviewTextAlphaNumeric;
            fontSize = isFourInchScreen ? 35 : 28;
            break;
        case 1:
            placeholderText = kFontPreviewTextQuickFox;
            fontSize = isFourInchScreen ? 40: 35;
            lineBreakMode = UILineBreakModeWordWrap;
            break;
        case 2:
            placeholderText = kFontPreviewTextNumeric;
            fontSize = isFourInchScreen ? 70 : 50;
            break;
        case 3:
            placeholderText = kFontPreviewTextSymbol;
            fontSize = isFourInchScreen ? 50 : 35;
            break;
        default:
            break;
    }
    
    [self resizeFontViewWithFont:[UIFont fontWithName:_font size:fontSize] text:placeholderText lineBreakMode:lineBreakMode];
    
}

- (void)resizeFontViewWithFont:(UIFont*)font text:(NSString*)text lineBreakMode:(UILineBreakMode)lineBreakMode {
    
    [[fontView editTextView] setFont:font];
    [[fontView editTextView] setText:text];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(fontView.editTextView.frame.size.width - 10, 1000) lineBreakMode:lineBreakMode];
    CGRect toolbarFrame = [fontView.previewTextControl convertRect:fontView.previewTextControl.frame toView:fontView];
    CGRect editViewFrame = CGRectMake(10, 45, self.view.frame.size.width - 20, MIN(size.height + 20, toolbarFrame.origin.y - 44*4));
    [UIView animateWithDuration:0.25f delay:0.00f options:UIViewAnimationCurveEaseIn animations:^{
        fontView.editTextView.frame = editViewFrame;
        fontView.fontSizeSlider.center = CGPointMake(self.view.frame.size.width / 2, (CGRectGetMaxY(editViewFrame) + toolbarFrame.origin.y) / 2);
        [[fontView fontSizeSlider] setValue:font.pointSize];
    }completion:^(BOOL finished){}];
}

- (void)prepareForState:(EditingState)editingState {
    
    if (editingState == kEditingStatePreview) {

        [self.navigationItem setRightBarButtonItem:familyButton animated:YES];
        [[fontView editTextView] resignFirstResponder];
        fontView.editTextView.editable = NO;
        fontView.editTextView.textAlignment = UITextAlignmentCenter;
        [self changePreviewText:nil];
        
        [UIView animateWithDuration:0.25f delay:0.00f options:UIViewAnimationCurveEaseIn animations:^{
            fontView.titleLabel.frame = CGRectMake(0, -10, self.view.frame.size.width, 44);
        }completion:^(BOOL finished){}];
        
    } else {
        
        [self.navigationItem setRightBarButtonItem:clearButton animated:YES];
        fontView.editTextView.editable = YES;
        [[fontView editTextView] becomeFirstResponder];
        [fontView.editTextView setText:@""];
        fontView.editTextView.textAlignment = UITextAlignmentLeft;
        [UIView animateWithDuration:.25 animations:^{
            fontView.titleLabel.frame = CGRectMake(0, -20, self.view.frame.size.width, 44);
            fontView.editTextView.frame = isFourInchScreen ? CGRectMake(10, 25, self.view.frame.size.width - 20, 160) : CGRectMake(10, 25, self.view.frame.size.width - 20, 100);
            fontView.fontSizeSlider.frame = isFourInchScreen ? CGRectMake(50, 215, 220, 20) : CGRectMake(50, 142, 220, 20);
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
