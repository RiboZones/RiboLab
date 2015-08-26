function frametrans(seq)

disp('5''3'' Frame 1')
viewseqt(seq(1,:))
fprintf('\n');

disp('5''3'' Frame 2')
viewseqt(seq(1,2:end-2))
fprintf('\n');

disp('5''3'' Frame 3')
viewseqt(seq(1,3:end-1))
fprintf('\n');

