//
//  Region.h
//

@interface Region : NSObject

+ (NSArray*)allRegions;
- (NSString*)name;
- (NSString*)timeZoneAtIndex:(NSUInteger)index;
- (NSMutableArray*)timeZones;
- (NSUInteger)timeZoneCount;

@end
