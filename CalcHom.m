function H = CalcHom(BlueBlobs)
    Q = [20 380; 200 380; 380 380; 20 200; 200 200; 380 200; 20 20; 200 20; 380 20];
    Pb = Q;
    index = 2; % Exclude background, as background is at position 1.
    for i = BlueBlobs
        Pb(index) = i.p;
        index = index + 1;
    end
    H = homography(Pb, Q');
end