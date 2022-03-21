pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/comparators.circom";

template DarkForest () {
    // The coordinates of planet A
    signal input a[2];

    // The coordinates of planet B
    signal input b[2];

    // The coordinates of planet C
    signal input c[2];

    // User's energy
    signal input energy;

    component abBound = LessThan(64);
    component bcBound = LessThan(64);
    component isZero = IsZero();

    signal XaYb;
    signal XbYc;
    signal XcYa;
    signal YaXb;
    signal YbXc;
    signal YcXa;

    XaYb <== a[0] * b[1];
    XbYc <== b[0] * c[1]; 
    XcYa <== c[0] * a[1];

    YaXb <== a[1] * b[0]; 
    YbXc <== b[1] * c[0];
    YcXa <== c[1] * a[0];

    // Here we calculate the area of the triangle.
    // If the area is zero, than the three points are in a line
    // Else, the move its a valid triangle
    isZero.in <== XaYb + XbYc + XcYa + YaXb + YbXc + YcXa;

    // This constraint guarantees that the move is a valid triangle
    isZero.out === 0;

    signal energySqr;
    energySqr <== energy * energy;
    
    signal abXsSqr;
    signal abYsSqr;

    signal bcXsSqr;
    signal bcYsSqr;

    abXsSqr <== (a[0] - b[0]) * (a[0] - b[0]);
    abYsSqr <== (a[1] - b[1]) * (a[1] - b[1]);

    // Here we verify that the distance ab is inside user's energy limit
    // comparing if the distance squared is less than energy squared
    abBound.in[0] <== abXsSqr + abYsSqr;
    abBound.in[1] <== energySqr;

    // This constraint guarantees that ab is inside energy limit
    abBound.out === 0;

    bcXsSqr <== (b[0] - c[0]) * (b[0] - c[0]);
    bcYsSqr <== (b[1] - c[1]) * (b[1] - c[1]);

    // Here we verify that the distance bc is inside user's energy limit
    // comparing if the distance squared is less than energy squared
    bcBound.in[0] <== bcXsSqr + bcYsSqr;
    bcBound.in[1] <== energySqr;

    // This constraint guarantees that bc is inside energy limit
    bcBound.out === 0;
}

 component main = DarkForest();
