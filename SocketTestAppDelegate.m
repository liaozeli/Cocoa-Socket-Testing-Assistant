//
//  SocketTestAppDelegate.m
//  SocketTest
//
//  Created by jimmyliao on 11-1-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocketTestAppDelegate.h"

@interface SocketTestAppDelegate (PrivateAPI)
- (void)logError:(NSString *)msg;
- (void)logInfo:(NSString *)msg;
- (void)logMessage:(NSString *)msg;
@end

@implementation SocketTestAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	NSLog(@"Welcome");
}

- (id)init
{
	if(self = [super init])
	{
		Socket = [[AsyncSocket alloc] initWithDelegate:self];
		isConnect = NO;
	}
	return self;
}

- (void)scrollToBottom
{
	NSScrollView *scrollView = [receivedmessage enclosingScrollView];
	NSPoint newScrollOrigin;
	
	if ([[scrollView documentView] isFlipped])
		newScrollOrigin = NSMakePoint(0.0, NSMaxY([[scrollView documentView] frame]));
	else
		newScrollOrigin = NSMakePoint(0.0, 0.0);
	
	[[scrollView documentView] scrollPoint:newScrollOrigin];
}

- (void)logMessage:(NSString *)msg
{
	NSString *paragraph = [NSString stringWithFormat:@"%@\n", msg];
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
	[attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	
	NSAttributedString *as = [[NSAttributedString alloc] initWithString:paragraph attributes:attributes];
	[as autorelease];
	
	[[receivedmessage textStorage] appendAttributedString:as];
	[self scrollToBottom];
}

-(IBAction)Connect:(id)sender
{
	int bind = [port intValue];
	
	if(bind < 0 || bind > 65535)
	{
		bind = 0;
	}
	NSError *error = nil;
	if (!isConnect) {
		[Socket connectToHost:[ip_address stringValue] onPort:bind error:&error];
		isConnect = YES;
		[ip_address setEnabled:NO];
		[port setEnabled:NO];
		[connect setTitle:@"Disconnect"];
	}
	else {
		[Socket disconnect];
		[connect setTitle:@"Connect"];
		[ip_address setEnabled:YES];
		[port setEnabled:YES];
		isConnect = NO;
	}

}

-(IBAction)Send:(id)sender
{
	NSLog(@"%@",[sendmessage stringValue]);
	NSData *data=[[sendmessage stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	[Socket writeData:data withTimeout:-1 tag:0];
}

#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
	if(flag)
		NSLog(@"onSocket:%p didSecure:YES", sock);
	else
		NSLog(@"onSocket:%p didSecure:NO", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock    //掉线处理
{
	isConnect = NO;
	[connect setTitle:@"Connect"];
	[ip_address setEnabled:YES];
	[port setEnabled:YES];
	NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	NSLog(@"%@",@"didAcceptNewSocket");
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	isConnect = YES;
	[Socket readDataWithTimeout:-1 tag:0];
	NSLog(@"%@",host);
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)t
{
	NSString *str=[NSString stringWithUTF8String:[data bytes]];
	NSLog(@"%@",str);
	//NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	//NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	[self logMessage:str];
	[Socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)t
{
	NSLog(@"%@",@"didReadPartialDataOfLength");
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)t
{
	NSLog(@"%@",@"didWriteDataWithTag");
}


@end
