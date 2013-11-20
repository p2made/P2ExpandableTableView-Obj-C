//
//  P2ViewController.m
//  P2ExpandableTableViewDemo
//

#import "P2ViewController.h"
#import "P2ExpandableTableView.h"
#import "Region.h"

@interface P2ViewController ()

@property (weak, nonatomic) IBOutlet P2ExpandableTableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (strong, nonatomic) NSArray* regionsData;

@end

@implementation P2ViewController {
	BOOL _animated;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	if (![super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
		return nil;
	_regionsData = [Region allRegions];
	_animated = YES;
	return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if (![super initWithCoder:decoder])
		return nil;
	_regionsData = [Region allRegions];
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[_tableView reloadData];
}

#pragma mark - User Actions

- (IBAction)toggleMultipleExpand:(UIButton*)sender
{
	BOOL newMode = ![_tableView multipleExpand];
	[_tableView setMultipleExpand:newMode];
	[sender setImage:[UIImage imageNamed:(newMode ? @"button_x" : @"button_m")] forState:UIControlStateNormal];
	[self updateModeLabel];
}

- (IBAction)toggleAnnimation:(UIButton*)sender
{
	BOOL newMode = !_animated;
	_animated = newMode;
	[sender setImage:[UIImage imageNamed:(newMode ? @"button_s" : @"button_a")] forState:UIControlStateNormal];
	[self updateModeLabel];
}

- (IBAction)toggleSectionFour:(UIButton*)sender
{
	[_tableView toggleSectionAtIndex:4 animated:_animated];
}

- (IBAction)toggleColors:(UIButton*)sender
{
	
}

- (void)updateModeLabel
{
	NSString* partOne = ([_tableView multipleExpand] ? @"multiple" : @"exclusive");
	NSString* partTwo = (_animated ? @"animated" : @"not animated");
	[_modeLabel setText:[NSString stringWithFormat:@"%@ / %@", partOne, partTwo]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [_regionsData count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	Region* region = _regionsData[section];
	return [region name];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	Region* regionForSection = _regionsData[section];
	return [regionForSection timeZoneCount];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* cellIdentifier = @"cell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	Region* regionForSection = _regionsData[[indexPath section]];
	NSString* text = [regionForSection timeZoneAtIndex:[indexPath row]];
	[[cell textLabel] setText:text];
	return cell;
}

#pragma mark UITableViewDelegate

- (UIView*)tableView:(P2ExpandableTableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	P2ExpandableSectionHeader* sectionHeader = [tableView expandableSectionHeaderAtIndex:section];
	if (sectionHeader)
		return sectionHeader;
	sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kP2ExpandableHeaderIdentifier];
	[tableView addExpandableSectionHeader:sectionHeader withIndex:section];
	return sectionHeader;
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	return nil;
}

@end
