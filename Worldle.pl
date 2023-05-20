
build_kb:-write('Please enter a word and its category on separate lines:'),nl,read(A),(A=done;(A\=done,read(B),assert(word(A,B)),build_kb)).



is_category(C):- word(A,C).


categories(L):- setof(C,is_category(C),L2),permutation(L2,L).


available_length(L):-  word(A,_),string_length(A,L).

pick_word(W,L,C):- word(W,C),string_length(W,L).

correct_letters([],L2,[]).
correct_letters([H|T],L2,[H2|T2]):-(\+member(H,T)),member(H,L2),H2=H,correct_letters(T,L2,T2).
correct_letters([H|T],L2,Res):-((\+member(H,L2));(member(H,T),member(H,L2))),correct_letters(T,L2,Res).

correct_positions([],[],[]).
correct_positions([H|T],[H|T1],[H|T2]):-correct_positions(T,T1,T2).
correct_positions([H|T],[H1|T1],Res):-H\=H1,correct_positions(T,T1,Res).

choose_category(C2):-write('Choose a category: '),nl,read(C),((is_category(C),C2=C);((\+is_category(C),
       write('This category does not exist.'),nl,choose_category(C2)))).

choose_length(A,C):-write('Choose a length: '),nl,read(L),((pick_word(W,L,C),A=L,write('Game started. You have '),L2 is L+1,write(L2),
write(' guesses.'),nl,nl);
((\+pick_word(W,L,C)),write('There are no words of this length.'),nl,choose_length(A,C))).

check_length(A,Word,Acc,C):-read(W),string_length(W,L),((Acc>0,A\=L,write('Word is not composed of '),write(A),write(' letters. Try again.'),nl,
write('Remaining guesses are '),write(Acc),nl,nl,write('Enter a word composed of '),write(A), write(' letters: '),nl,check_length(A,Word,Acc,C));(Acc=1,
A=L,Word=W,atom_chars(W,List),pick_word(W2,A,C),atom_chars(W2,List2),
correct_letters(List,List2,Common),correct_positions(List,List2,Correct),(length(Correct,Length),Length=A,write('You won!');
length(Correct,Length),Length\=A,write('You Lost!')));(Acc>0,Acc\=1,A=L,Word=W,NewAcc is Acc-1,atom_chars(W,List),pick_word(W2,A,C),atom_chars(W2,List2),
correct_letters(List,List2,Common),correct_positions(List,List2,Correct),length(Correct,Length),(Length=A,write('You won!');Length\=A,
write('Correct letters are: '),write(Common),nl,write('Correct letters in correct positions are: '),write(Correct),nl,
write('Remaining guesses are '),write(NewAcc),nl,nl,write('Enter a word composed of '),write(A), write(' letters: '),nl,check_length(A,Word2,NewAcc,C)))).


main:-build_kb,nl,play.

play:-write('The available categories are: '),categories(L),write(L),nl,choose_category(C),nl,
choose_length(A,C),write('Enter a word composed of '),write(A), write(' letters: '),nl,A2 is A+1,check_length(A,W,A2,C).