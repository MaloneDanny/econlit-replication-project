This script is intended to use R to query the JSTOR API for metadata on large quantities of articles at once.  Detailed instructions/explainations for how the script functions are included as part of the code of the script itself.  Bugs should be reported to the GitHub bug report feature, or to email Daniel Malone at malonedanny@hotmail.com.

The script is in R, to be used with R Studio.  R and R Studio are both required in order to run the script, the instructions to download both can be located here:  https://rstudio-education.github.io/hopr/starting.html

The script is able to use the JSTOR API to collect metadata from articles with identification numbers which are in sequence with each other.  Commonly, when articles are added to the JSTOR database, the journal issue that they appear in will all be included at the same time.  This means that they will be given identification numbers which are sequential and increase by one for each article.  The script takes advantage of this by querying the API for the metadata for each article in the sequence.  This allows for the collection of a large amount of metadata of articles at the same time.  The script saves the collected and cleaned metadata as a .csv file, so it may be used by both spreadsheet editors like Excel or Google Sheets, and they can also be imported into statistical software like R or Stata directly.

As noted, the script uses the identification number of articles on JSTOR to function;  finding the identification number is a simple process, as it is included on the URL of each article.  An example of an article URL is the following:

https://www.jstor.org/stable/27086712

In this example, the identification number would be "27086712".  This is the number that one should put into the script to collect it's metadata.  To collect the entire issue's worth of articles, navigate to the webpage for the issue in question (in this case, Vol. 111, No. 12, DECEMBER 2021 of the American Economic Review), find the identification number of the first article (Note: the first full research article, do not include opening remarks, etc.) and the identification number of the last article, and use them as the "start" and "end" numbers of the function in the script.  

To use the script, use CTRL + ENTER to run the line of code that your cursor is on, or CTRL + ALT + R to run the entire script at once.  Run the entire script all the way to the bottom, and then you can use the function 'yoinkdata' to glean metadata from JSTOR's server.  To use yoinkdata, type "yoinkdata" in either the console or the script editor, then type in the identification number of the first research article in parenthenses "()", followed by the last research article in the same parentheses, separated by a comma ",".  An example of the proper use of yoinkdata is as follows:

yoinkdata(27028273,27028281)

To avoid errors, avoid doing the following:
1) Do not try to read multiple journal issues at once
2) Always input the beginning identification number first, and the ending identification number second


The variables that the function is able to glean include:
	abstract:  If included, the abstract of the paper is recorded under this column in it's entirety.  Future research may wish to use text mining techniques to identify keywords which are relevant to the study.

	authors:  This variable, using the function, records only the primary author of the paper.  Be advised that if there are multiple authors of the paper, the function is unable to record them, and any additional authors must be recorded by hand.

	issue:  The issue that the article appears in is recorded here.

	journal: The journal that the article appears in is recorded here.

	page_count: The number of pages of the article is recorded here.

	pubdate:  The date and time that the article was uploaded to JSTOR is recorded here.  This may overlap with the true publication date of the journal.

	volume:  The volume that the article appears in is recorded here.

	year:  The year the article was publsihed is recorded here.

	title:  The combined title and subtitle of the article is recorded here.  Be advised that if the title includes non-standard characters such as ('), they will appear as raw text, and will need to be corrected manually.