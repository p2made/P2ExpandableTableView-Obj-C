//
//  P2ExpandableSectionHeaderView.m
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

@interface P2ExpandableSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

@end

@implementation P2ExpandableSectionHeader

#pragma mark - P2ExpandableSectionHeaderView Lifecycle

-(void)awakeFromNib
{
    [_indicator setImage:[UIImage imageNamed:@"section_expanded"] forState:UIControlStateSelected];
    [_indicator setImage:[UIImage imageNamed:@"section_collapsed"] forState:UIControlStateNormal];
}

#pragma mark - properties

- (BOOL)isExpanded
{
	return [_indicator isSelected];
}

- (void)setExpanded:(BOOL)expanded
{
	[_indicator setSelected:expanded];
}

- (UILabel*)textLabel
{
	return _titleLabel;
}

- (NSString*)title
{
	return [_titleLabel text];
}

- (void)setTitle:(NSString*)title
{
	[_titleLabel setText:title];
}

@end
