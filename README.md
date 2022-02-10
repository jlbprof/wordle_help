# I am grateful to this project

https://github.com/dwyl/english-words

I was able to get a large english word list from their project.

## Finding an opening word

For a long time I used GREAT as my opening word and I had good success with that.  But is there a better word?

./wordle_opening_word.pl CA2 CE2 CI2 CO2 CU1 CS1 CT1 CR1 CL1

## Using wordle_help.pl

    usage: wordle_help [clues]
        clues: AX3, character X is at position 3
            NX3, character X is present but NOT at position 3
            XX,  character X is NOT present
        Positions are 1 based

## Best 2nd Guess

./wordle_best_from.pl NR1 NA2 XT XI XO XXX CA2 CE2 CI2 CO2 CU1 CS1 CT1 CR1 CL1

## Here is one session that I did, using the help of these programs.

The puzzle on 2022-02-10 the answer was: PAUSE

I have settled on the first guess as always being AISLE because of all the
vowels and S and L.  I found this word by using this script.

./wordle_opening_word.pl CA2 CE2 CI2 CO2 CU1 CS1 CT1 CR1 CL1
Where:

CA2
CE2
CI2
CO2 - Look for A, E, I and O and if you see them add to the words rank 2.

CU1
CS1
CT1
CR1
CL1 - Look for U, S, T, R and L and if you see them add to the words rank 1.

This returns 67 words of which AISLE I like best.

So I guess AISLE

I get the following clues:

XI   - 'I' is not present.
XL   - 'L' is not present.
NA1  - 'A' is present but not at position 1.
NS3  - 'S' is present but not at position 3.
AE5  - 'E' is present and at position 5.

I then run my 2nd guess program.

./wordle_best_from.pl XI XL NA1 NS3 AE5 XXX CA2 CE2 CI2 CO2 CU1 CS1 CT1 CR1 CL1

This takes my clues and then out of the choices produced, ranks them by the same
rules as my first guess program.

So I guess STOAE

I do not know what that means but it is acceptable to Wordle.  It has more
vowels and S and T common consonents.

That guess generates these clues:

XT XO NS1 NA4 XI XL NA1 NS3 AE5

I consolidated some of the clues.

./wordle_help.pl XT XO NS1 NA4 XI XL NA1 NS3 AE5
This generates 31 words.

Of which I choose:

CEASE

Clues:
XC NA3 AS4

./wordle_help.pl AE5 AS4 NA1 NA3 NA4 XC XI XL XO XT

This generates 17 words, but most were wierd words but I found
PAUSE which turns out to be the solution.

