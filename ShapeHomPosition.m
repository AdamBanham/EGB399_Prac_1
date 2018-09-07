function pos = ShapeHomPosition(H, blob)
    p = [blob.uc, blob.vc];
    disp(p);
    pos = homtrans(H, p');
end