function val = blkxor2(neib)

pos=[1,4,7,8,9,6,3,2];
val=bin2dec(int2str(xor(neib(pos),neib(5))));


