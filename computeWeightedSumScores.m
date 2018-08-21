function pw=computeWeightedSumScores(p)
    w=[0.8 0.60 0.5 0.32 0.6 0.6 0.5
       0.1 0.15 0.2 0.35 0.1 0.2 0.3
       0.1 0.25 0.3 0.33 0.3 0.2 0.2];
   if size(p,1)==size(w,2) && size(p,2)==size(w,1)
       pw=p*w;
   else
       pw=p;
   end
   
   pw=diag(pw);
end