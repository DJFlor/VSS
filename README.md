# VSS
Example style sheet implementation for UIView sub-classes in iOS

Does it work for everything? No, of course it doesn't!

I wrote this as a thought excercise, to see what could be accomplished in this arena in only a single day, and as such I have only solved the simplest of the associated problems.

What can it do?  Well, it allows you to style the background colors and label text and colors for UIViews and UILabels, so far, just by editing a plist.  And you can use sub-classed views implementing the stylable protocol to indicate which style you want to apply to the view, right from the storyboard.  There's room to extend it quite a bit, and I'll likely get around to it sooner or later.

I really wrote this to show prospective employers what I can accomplish in just a day, and to demonstrate my favorite iOS combo trick.

1.) extend a foundation class via category with a new method that you want invoked in-line with a built-in method.
    See: UIView+StyleSheet.m line 15.
2.) add a second method that calls the method from (1), then calls itself.
    See: UIView+StyleSheet.m line 30.
3.) add a third method (must be static) to swizzle the built-in method with your method from (2) using the objective c runtime.
    See: UIView+StyleSheet.m line 20.
4.) create a PCH that imports your category file _everywhere_ thereby adding your category to every instance of the class.
    See: project / Build Settings / Apple LLVM 7.0 - Language (or 6.0 if you're still on XCode 6)
5.) invoke your swizzle method either in the app delegate or main, swapping implementations and hijacking the foundation method.
    See: AppDelegate.m line 21.
6.) sit back, feel clever, and reflect on what evil thou hath wrought.

Now WHY on god's green earth would you want to do such a thing?  Well, for this example, I'm using it to force every UIView to auto-magickally style itself when it's layoutSubview methods are called.  That's pretty evil.

You can also use this trick to do uber-debug prints from foundation methods.  As in, you could use this method to print to the log every time a class registers or deregisters itself as a listener for notifications, or posts a notification.  Everywhere.  From ANY class, yours, some other guy's, or even Apple's.  What's that? Forcing apple to divulge all of its internal notification architecture?  Downright INSIDIOUS.

File this under Power Tools, and make sure you wear your safety glasses when you use it!

Dan "ObiDan" Flor
