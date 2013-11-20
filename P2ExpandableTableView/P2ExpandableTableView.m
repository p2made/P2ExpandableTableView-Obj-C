//
//  P2ExpandableTableView.m
//  P2ExpandableTableView
//
//  Copyright (c) 2013 Pedro Plowman
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "P2ExpandableTableView.h"
#import "P2ExpandableSectionHeader.h"

#define kP2ExpandableHeaderHeight		35.0

@interface P2ExpandableTableView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<UITableViewDataSource> expandDataSource;
@property (weak, nonatomic) id<UITableViewDelegate> expandDelegate;
@property (strong, nonatomic) NSMutableSet* sectionHeaderSet;

@end

@implementation P2ExpandableTableView {
	NSUInteger _expandedSectionIndex;
}

#pragma mark - View Lifecycle

- (id)initWithCoder:(NSCoder*)aDecoder
{
	if (![super initWithCoder:aDecoder])
		return nil;
	[self initialiseExpandableTableView];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (![super initWithFrame:frame])
		return nil;
	[self initialiseExpandableTableView];
	return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if (![super initWithFrame:frame style:style])
		return nil;
	[self initialiseExpandableTableView];
	return self;
}

- (void)initialiseExpandableTableView
{
	_multipleExpand = NO;
    _shouldHandleHeadersTap = YES;
	_expandedSectionIndex = NSNotFound;
	[self setSectionHeaderHeight:kP2ExpandableHeaderHeight];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"P2ExpandableSectionHeader" bundle:nil];
    [self registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:kP2ExpandableHeaderIdentifier];
}

- (void)setDataSource:(id <UITableViewDataSource>)newDataSource
{
	if (newDataSource == _expandDataSource)
		return;
	_expandDataSource = newDataSource;
	[super setDataSource:(_expandDataSource ? self : nil)];
}

- (void)setDelegate:(id<UITableViewDelegate>)newDelegate
{
    if (newDelegate == _expandDelegate)
		return;
	_expandDelegate = newDelegate;
	[super setDelegate:(_expandDelegate ? self : nil)];
}

#pragma mark - Expandable Section Headers

- (P2ExpandableSectionHeader*)expandableSectionHeaderAtIndex:(NSUInteger)index
{
	for (P2ExpandableSectionHeader* sectionHeader in _sectionHeaderSet) {
		if (index == [sectionHeader tag])
			return sectionHeader;
	}
	return nil;
}

- (void)addExpandableSectionHeader:(P2ExpandableSectionHeader*)sectionHeader withIndex:(NSUInteger)index
{
	if (!_sectionHeaderSet)
		_sectionHeaderSet = [NSMutableSet setWithCapacity:[_expandDataSource numberOfSectionsInTableView:self]];
	[sectionHeader setTag:index];
	[sectionHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSectionWithTap:)]];
	[_sectionHeaderSet addObject:sectionHeader];
}

#pragma mark - Expand/Collapse actions

- (void)toggleSectionWithTap:(UITapGestureRecognizer*)tap
{
	NSUInteger tappedIndex = [[tap view] tag];
	[self toggleSectionAtIndex:tappedIndex animated:YES];
}

- (void)toggleSectionAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	BOOL isExpanded = [self isExpandedSectionAtIndex:index];
	if (isExpanded)
		[self collapseSectionAtIndex:index animated:animated];
	else
		[self expandSectionAtIndex:index animated:animated];
}

- (void)expandSectionAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	NSUInteger previousIndex = [self expandedSectionIndex];
	if (_multipleExpand || (NSNotFound == previousIndex))
		[self expandWithNoCollapseSectionAtIndex:index animated:animated];
	else
		[self expandSectionAtIndex:index collapsingSection:previousIndex animated:animated];
}

- (void)collapseSectionAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	_expandedSectionIndex = NSNotFound;
	[self setExpanded:NO sectionAtIndex:index];
	NSArray* indexPathsToDelete = [self indexPathsForSectionAtIndex:index];
	[self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
}

- (BOOL)isExpandedSectionAtIndex:(NSUInteger)index
{
	return [[self expandableSectionHeaderAtIndex:index] isExpanded];
}

#pragma mark - Private methods

- (void)expandWithNoCollapseSectionAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	if (!_multipleExpand)
		_expandedSectionIndex = index;
	[self setExpanded:YES sectionAtIndex:index];
	if (!animated) {
		[self reloadData];
		return;
	}
	NSArray* indexPathsToInsert = [self indexPathsForSectionAtIndex:index];
	[self beginUpdates];
	[self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
	[self endUpdates];
}

- (void)expandSectionAtIndex:(NSUInteger)expandIndex collapsingSection:(NSUInteger)collapseIndex animated:(BOOL)animated
{
	_expandedSectionIndex = expandIndex;
	[self setExpanded:YES sectionAtIndex:expandIndex];
	[self setExpanded:NO sectionAtIndex:collapseIndex];
	if(animated) {
		[self reloadData];
		return;
	}
	NSArray* indexPathsToInsert = [self indexPathsForSectionAtIndex:expandIndex];
	NSArray* indexPathsToDelete = [self indexPathsForSectionAtIndex:collapseIndex];
	UITableViewRowAnimation insertAnimation;
	UITableViewRowAnimation deleteAnimation;
	if (expandIndex < collapseIndex) {
		insertAnimation = UITableViewRowAnimationTop;
		deleteAnimation = UITableViewRowAnimationBottom;
	} else {
		insertAnimation = UITableViewRowAnimationBottom;
		deleteAnimation = UITableViewRowAnimationTop;
	}
	[self beginUpdates];
	[self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
	[self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
	[self endUpdates];
}

- (NSArray*)indexPathsForSectionAtIndex:(NSUInteger)sectionIndex
{
	NSInteger numberOfRows = [_expandDataSource tableView:self numberOfRowsInSection:sectionIndex];
	if (0 == numberOfRows)
		return [NSArray array];
	NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:numberOfRows];
	for (int i = 0 ; i < numberOfRows ; i++)
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
    return [NSArray arrayWithArray:indexPaths];
}

- (void)setExpanded:(BOOL)expanded sectionAtIndex:(NSUInteger)index
{
	[[self expandableSectionHeaderAtIndex:index] setExpanded:expanded];
}

- (NSUInteger)expandedSectionIndex
{
    if (_multipleExpand)
		return NSNotFound;
	for (P2ExpandableSectionHeader* sectionHeader in _sectionHeaderSet) {
		if ([sectionHeader isExpanded])
			return [sectionHeader tag];
	}
    return NSNotFound;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [_expandDataSource numberOfSectionsInTableView:tableView];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	if (![_expandDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
		return nil;
	return [_expandDataSource tableView:self titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	if (![self isExpandedSectionAtIndex:section])
		return 0;
	return [_expandDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return [_expandDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Delegate

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
   return [_expandDelegate tableView:tableView viewForHeaderInSection:section];
}

@end
