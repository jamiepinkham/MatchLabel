want username and hashtag click regions like twitter?  use this.

basically, you create a MXMatchDescriptor, which has a regex for the match you want to create a tappable region for, and options for the font and color, highlight color and a tag for identifying different descriptors when they are triggered by tapping on their region.

make a bunch of these descriptors and add them to the MXMatchLabel, and your matches should be highlighted and tappable.  taps are handled by the delegate of the MXMatchLabel, which passes back the label, the match descriptor fired and the word that was tapped.

i made this really quickly and haven't scrubbed it for memory management goodness.

enjoy.