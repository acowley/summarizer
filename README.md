## An implementation of very simple text summarization

- Count word frequency, ignoring unimportant ("stop") words
- Pick out the first sentence in which each word occurs
- Present some number of those sentences in the order in which they appear in the input text

## Usage:

Pipe text into the `summarizer` program to get a 10 line summary, or prepend an integer for the desired summary length (in sentences) to the input text with a single space between the number and the text.
