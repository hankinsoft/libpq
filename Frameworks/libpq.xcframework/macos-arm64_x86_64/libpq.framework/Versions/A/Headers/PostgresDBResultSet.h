//
//  PostgresDBResultSet.h
//  libpq
//
//  Created by Kyle Hankinson on 2020-08-21.
//  Copyright © 2020 Kyle Hankinson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostgresDBResultSet : NSObject

- (BOOL) next: (NSError*__autoreleasing*) error NS_SWIFT_NOTHROW;
- (id) objectForColumnIndex: (NSUInteger) columnIndex;

@property(nonatomic,retain,readonly) NSArray<NSString*>* columnNames;

@end

NS_ASSUME_NONNULL_END
