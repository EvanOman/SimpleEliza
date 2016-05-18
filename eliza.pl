# Title: 		Eliza The Academic Advisor
# Author: 		Evan Oman
# Assignment: 	Programming Assignment 1
# Instructor: 	Ted Pedersen
# Course: 		CS 5761

# Sets up an associative array defining where we want each word to go
% replace = (
	I => "you",
	my => "your",
	You => "I",
	you => "me",
	your => "my",
	me => "you",
	She => "she",
	He => "he",
	she => "she",
	he => "he",
	am => "are",
	are => "am",
	"." => ""#
	Gets rid of annoying punctuation
);

#Used to store info about the user
% info = (
	name => "Student", #
	default 'name'
	major => "College"#
	default 'major'
);

#Looping variables
$cond = 1;
$totalQuestionResponseCounter = 0;

#Standard responses to be used later
$tellMeMore = ">Tell me more.\n";
$tryAgain = ">Sorry I didn't catch that, could you say it again?\n";
$changeSubject = ">Let's change the subject, is there anything else I can help you with?\n";
$askQuestionResponse = ">How can I help you today?\n";

#Arrays to store input and output
@inputArray = ();
@outputArray = ();

#Boiler - plate print
print "This is Eliza The Academic Advisor (PA 1 CS 5761 Fall 2014), programmed by Evan Oman.\n\n";

#Initial prompt
print ">Hello, I am your academic advisor Eliza. What is your name?\n";

while ($cond)
{
	my $input = getInput();
	if ($input!~/^([Ee]xit)$/)
	{
		#Need to get name / major first
		if (!@outputArray)
		{
			getNameMajor($input);
		}
		#Look for question words
		elsif($input = ~/\b(Who|What|Where|When|Why|How)\b/i)
		{
			handleQuestion($input);
			file: ///C:/users/evan~1.oma/appdata/local/temp/tmpye4u0r.html 1/4
				9 / 21 / 2014 C: \cygwin\ home\ evan.oman\ eliza.pl
		}
		#negative case
		elsif($input = ~/(do(n't| not) think|I won't|can't|don't want to)/)
		{
			printMessage(">You sound discouraged. ".$info {"major"}." is hard work but I think you can do it!\n ");
		}
			#Look for uncertainty
		elsif($input = ~/^(I('m| am) not sure|I do(n't| know))/)
		{
			printMessage(">".$info {"name"}.", I am concerned that you do not know much about your graduation plan.If you want to succeed at ".$info{"major "}."you must pay attention to the details.\n");
		}
				#Look for 'ask you a question' response
		elsif($input = ~/((ask you a| I have a) (\b(new|different|unrelated)\b\s)?question|ask you something(new | different | unrelated) ? ) / )
		{
			printMessage($askQuestionResponse);
		}
			#look for emotions
		elsif($input = ~/\b(overwhelmed|sad|emotional|angry|furious|hate|frustrated)\b/)
		{
			printMessage(">No need to get emotional, we will figure this out!\n");
		}
		# The I(blank) case with the question response
		elsif($input = ~/^\b(I|You|HeWha|She)\b \b(\w+)\b (\b(my|me)\b \b(\w+)(\.)?)?/i)
		{
			#
			The start of our responses
			$starter = "Why do you say ";
			#
			Performs the word mapping on our string
			$input = applyReflMapping($input);
			#
			Prints our response
			printMessage(">".$starter.$input."?\n");
		}
		else
		{
			printMessage($tellMeMore);
		}
	} 
	else
	{
		my $goodbye = ">Good bye";
		$goodbye = $goodbye.
		", ".$info {
			"name"
		}.
		", I hope you do well in ".$info {
			"major"
		};
		printMessage($goodbye.
			".\n");
		$cond = 0;
	}
}

#Used to get the input throughout the process
sub getInput
{
	print "<";
	my $input = < STDIN > ;
	chomp($input);
	#
	Add to list of inputs
	push(@inputArray, $input);
	return $input;
}

# Prints a message as long as it hasn't be printed twice consecutively
sub printMessage
{
	my $message = $_[0];
	push(@outputArray, $message);
	my $arrLength = @outputArray;
	#Don 't want a loop, restart the conversation if I have said the same thing more than twice in a
	row
	if ($arrLength >= 3 && $outputArray[-1] eq $outputArray[-2] && $outputArray[-1] eq
		$outputArray[-3])
	{
		printMessage($changeSubject);
	} else
	{
		print $message;
	}
}

#Applies the mapping which reflects a statement into a question
sub applyReflMapping 
{
	my $a = $_[0];
	$a = ~s / \b(I | my | [Yy] ou | your | me | [Ss] he | [Hh] e | am | are | \.)\ b / $replace {
		$1
	}
	/eg;
	return $a;
}

#Gets and stores the name of the user and calls the getMajor function
sub getNameMajor
{
	my $haveName = 0;
	my $input = $_[0];
	while (!$haveName)
	{
		if (!$input)
		{
			$input = getInput();
		}
		if ($input!~/^([Ee]xit)$/)
		{
			# Want to keep trying to get the name
			if ($input = ~s / ^ ((Hello, ? | Hi, ? ) ? ? ([Mm] y name is | I am | [Cc] all me | I'm))?\b(\w + )\ b / $4 / eg)
			{
				$info {"name"} = $input;
				printMessage(">Nice to meet you ".$input.", what is your major?\n");
				$haveName = 1;
				getMajor();
			}
			else
			{
				printMessage($tryAgain);
				#If this is true then we looped for too long
				if ($outputArray[-1] ne $tryAgain)
				{
					$haveName = 1;
				}
			}
		}
		else
		{
			$haveName = 1;
			$cond = 0;
		}
		$input = 0;
	}
}

#Gets and stores the major of the user
sub getMajor 
{
	my $haveMajor = 0;

	while (!$haveMajor) {
		my $input = getInput();
		if ($input!~/^([Ee]xit)$/)
		{
			#Want to keep trying to get the name
			if ($input = ~s / ^ (([Mm] y major is | I am majoring in )) ? (\b(\w + )\ b) + /$4/eg) {
				$info {"major"} = $input;
				printMessage(">I have always been interested in ".$input.", do you like it so far?\n");
				$haveMajor = 1;
			}
			else
			{
				printMessage($tryAgain);

				#If this is true then we looped for too long
				if ($outputArray[-1] ne $tryAgain)
				{
					$haveMajor = 1;
				}
			}
		}
		else
		{
			$haveMajor = 1;
			$cond = 0;
		}
		$input = 0;
	}
}

# handles statements in question form
sub handleQuestion
{
	#Every other question we will respond with "check google"
	if ($totalQuestionResponseCounter % 2 == 0)
	{
		my $input = $_[0];
		$input = ">".applyReflMapping($input).
		"\n";
		$middle = "do you think";#
		Need to clean out the 'do'
		s
		$input = ~s / \b[Dd] o\ b\ s //;
		$input = ~s / \b([Ww] ho | [Ww] hat | [Ww] here | [Ww] hen | [Ww] hy | [Hh] ow much\ b(\w + ) | [Hh] ow many\ b(\w + ))\ b / $1 $middle / ;
		printMessage($input);
	}
	else
	{
		printMessage(">Have you tried this wonderful resource called Google?\n");
	}
	$totalQuestionResponseCounter++;
}