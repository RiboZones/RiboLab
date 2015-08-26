if (isunix)
	mex -Dfalse=0 -Dtrue=1 neighbor.c phylip.c dist.c
else
	mex -DWIN32 -Dfalse=0 -Dtrue=1 neighbor.c phylip.c dist.c
end

