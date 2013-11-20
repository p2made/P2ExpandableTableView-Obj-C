//
//  P2ExpandableTableView.h
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

#import "P2ExpandableSectionHeader.h"

#define kP2ExpandableHeaderIdentifier	@"P2ExpandableHeader"

@interface P2ExpandableTableView : UITableView

@property (nonatomic, assign) BOOL multipleExpand;
@property (nonatomic, assign) BOOL shouldHandleHeadersTap;

- (P2ExpandableSectionHeader*)expandableSectionHeaderAtIndex:(NSUInteger)index;
- (void)addExpandableSectionHeader:(P2ExpandableSectionHeader*)sectionHeader withIndex:(NSUInteger)index;

- (void)toggleSectionAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)expandSectionAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)collapseSectionAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (BOOL)isExpandedSectionAtIndex:(NSUInteger)index;

@end
