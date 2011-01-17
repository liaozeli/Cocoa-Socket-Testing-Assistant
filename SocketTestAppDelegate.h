//
//  SocketTestAppDelegate.h
//  SocketTest
//
//  Created by jimmyliao on 11-1-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

@class AsyncSocket;

@interface SocketTestAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	AsyncSocket *Socket;
	
	BOOL isConnect;
	IBOutlet id ip_address;
	IBOutlet id port;
	IBOutlet id sendmessage;
	IBOutlet id receivedmessage;
	IBOutlet id connect;
	IBOutlet id send;
}

@property (assign) IBOutlet NSWindow *window;
-(IBAction)Connect:(id)sender;
-(IBAction)Send:(id)sender;

@end
