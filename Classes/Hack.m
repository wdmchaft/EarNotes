/*
 JANSLogHack
 By Jens Ayton
 Use of constructor attribute suggested by Jonathan Wight.
 
 Add this file to your project to cause NSLog() messages to be printed to
 standard out.
 
 It is the opinion of the author of this file that it does not have
 sufficient depth to constitute a "work" for the purposes of copyright, and
 is therefore in the public domain by default. If you disagree with this
 assessment, you may contact the author for licensing terms via any of
 several e-mail addresses found at <http://jens.ayton.se/>.
 
 The _NSSetLogCStringFunction() is documented at
 <http://docs.info.apple.com/article.html?artnum=70081> (in the context of
 WebObjects 4 for Windows NT). However, note that the documentation clearly
 states that the function is private and unsupported. It is strongly
 recommended that this code not be used in production code.
 
 For completeness, I should mention that there is a matching undocumented
 getter, _NSLogCStringFunction(), which takes no parameters and returns a
 function pointer.
 */
/*

#ifndef NDEBUG

#import <Foundation/Foundation.h>
#import <stdio.h>

extern void _NSSetLogCStringFunction(void (*)(const char *string, unsigned length, BOOL withSyslogBanner));


static void PrintNSLogMessage(const char *string, unsigned length, BOOL withSyslogBanner)
{
	puts(string);
}


static void HackNSLog(void) __attribute__((constructor));
static void HackNSLog(void)
{
	_NSSetLogCStringFunction(PrintNSLogMessage);
}

#endif
*/