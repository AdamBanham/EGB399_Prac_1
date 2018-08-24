function pos = ShapeHomPosition(H, blob)
    p = blob.p;
    pos = homtrans(H, p');
end