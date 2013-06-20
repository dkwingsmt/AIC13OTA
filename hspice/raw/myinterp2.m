function [ res ] = myinterp2( amat, bvec, cmat, Va, Vb )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a_once = zeros(1, length(bvec));

for i = 1:length(bvec)
    avec = amat(:, i);
    cvec = cmat(:, i);
    [avec, idx] = sort(avec);
    cvec = cvec(idx);
    a_once(i) = interp1(avec, cvec, Va);
end
bvec2 = bvec(~isnan(a_once));
avec2 = a_once(~isnan(a_once));

res = interp1(bvec2, avec2, Vb);

end
