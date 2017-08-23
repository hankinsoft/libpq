//
//  libpq.h
//  libpq
//
//  Created by Kyle Hankinson on 8/23/17.
//  Copyright © 2017 Kyle Hankinson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for libpq.
FOUNDATION_EXPORT double libpqVersionNumber;

//! Project version string for libpq.
FOUNDATION_EXPORT const unsigned char libpqVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <libpq/PublicHeader.h>

#import "libpq-fe.h"
#include "postgres_ext.h"
