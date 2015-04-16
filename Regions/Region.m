//
//  Region.m
//

#import "Region.h"

@interface Region ()

@property (nonatomic, copy) NSString* name;
@property (strong, nonatomic) NSMutableArray* timeZones;

@end

@implementation Region

static NSArray* _allRegions = nil;

+ (NSArray*)allRegions
{
	if (_allRegions)
		return _allRegions;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_allRegions = [self fetchAllRegions];
	});
	return _allRegions;
}

+ (NSArray*)fetchAllRegions
{
	NSArray* knownTimeZoneNames = [NSTimeZone knownTimeZoneNames];
	NSMutableArray* regionsTemp = [NSMutableArray array];
	
	for (NSString* fullTimeZoneName in knownTimeZoneNames) {
		NSArray* nameComponents = [fullTimeZoneName componentsSeparatedByString:@"/"];
		NSString* regionName = nameComponents[0];
		
		Region* region;
		for (Region* aRegion in regionsTemp) {
			if (![[aRegion name] isEqualToString:regionName])
				continue;
			region = aRegion;
			break;
		}
		if (!region) {
			region = [[Region alloc] initWithName:regionName];
			[regionsTemp addObject:region];
		}
		
		NSString* newTimeZoneName = [self newTimeZoneNameWithNameComponents:nameComponents];
		[[region timeZones] addObject:newTimeZoneName];
	}
	
	// Sort the regions
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [regionsTemp sortUsingDescriptors:sortDescriptors];
	
	// Now sort the time zones by name
	for (Region* aRegion in regionsTemp) {
		[[aRegion timeZones] sortedArrayUsingSelector:@selector(compare:)];
	}
	
	int i = 0;
	for (Region* aRegion in regionsTemp) {
		int count = (int)[[aRegion timeZones] count];
		[aRegion setName:[NSString stringWithFormat:@"%@ (%i, %i)", [aRegion name], i, count]];
		i++;
	}
	
	return [NSArray arrayWithArray:regionsTemp];
}

- (instancetype)initWithName:(NSString*)regionName
{
	if (![super init]) return nil;
	_name = [regionName copy];
	_timeZones = [NSMutableArray array];
	return self;
}

- (NSString*)name
{
	return _name;
}

- (NSString*)timeZoneAtIndex:(NSUInteger)index
{
	return _timeZones[index];
}

- (NSMutableArray*)timeZones
{
	return _timeZones;
}

- (NSUInteger)timeZoneCount
{
	return [_timeZones count];
}

+ (NSString*)newTimeZoneNameWithNameComponents:(NSArray*)nameComponents
{
	if (1 == [nameComponents count])
		return @"UTC";
	NSString *name;
	if (2 == [nameComponents count])
		name = nameComponents[1];
	else
		name = [NSString stringWithFormat:@"%@ (%@)", nameComponents[2], nameComponents[1]];
	return [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

@end
