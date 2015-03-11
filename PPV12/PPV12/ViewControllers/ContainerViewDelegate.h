//
//  ContainerViewDelegate.h
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#ifndef PPV12_ContainerViewDelegate_h
#define PPV12_ContainerViewDelegate_h


@protocol ContainerViewDelegate <NSObject>

@required
- (void)openMenu;
-(void) closeMenu:(NSString*) page;

@end


#endif
