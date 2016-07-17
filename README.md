# Very simple text summarization

## Usage
Pipe text into the `summarize` program to get a 10 sentence summary, or prepend an integer for the desired summary length (in sentences) to the input text with a single space between the number and the text, or give `summarize` a numeric option to specify the maximum summary length.

## Example

```
$ curl http://www.gutenberg.org/cache/epub/1342/pg1342.txt 2>/dev/null | stack exec summarize -- 5
"My dear Mr. Bennet," said his lady to him one day, "have you heard that Netherfield Park is let at last.

Only think what an establishment it would be for one of them.

"But you forget, mamma," said Elizabeth, "that we shall meet him at the assemblies, and that Mrs. Long promised to introduce him.

Not all that Mrs. Bennet, however, with the assistance of her five daughters, could ask on the subject, was sufficient to draw from her husband any satisfactory description of Mr. Bingley.

His brother-in-law, Mr. Hurst, merely looked the gentleman; but his friend Mr. Darcy soon drew the attention of the room by his fine, tall person, handsome features, noble mien, and the report which was in general circulation within five minutes after his entrance, of his having ten thousand a year.
```


## Algorithm
- Count word frequency, ignoring unimportant ("stop") words
- Pick out the first sentence in which each word occurs
- Present some number of those sentences in the order in which they appear in the input text
