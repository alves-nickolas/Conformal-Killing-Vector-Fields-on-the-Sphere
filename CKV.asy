    size(8cm); // fixing size to ensure arrows are an appropriate size
    import three; // 3D graphics

    triple spherical(real theta, real phi) {
        return (sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta));
    } // function converting spherical angles to Cartesian coordinates
    
    currentprojection = perspective(spherical(pi/5,-pi/5)); // choice of point of view
    
    draw(unitsphere,surfacepen=material(diffusepen=lightgray,emissivepen=darkgray, specularpen=black)); // draws the sphere

    real cot(real x) {
        return cos(x)/sin(x);
    } // cotangent function is used in defining stereographic coordinates

    pair stereographic(real theta, real phi) {
        real r = cot(theta/2);
        return (r*cos(phi), r*sin(phi)); // complex z as (x,y)
    } // converts spherical input to (real) stereographic

    pair Y(real x, real y) {
        real x2 = x*x;
        real y2 = y*y;
        return (x-y,y+x);
    } // spherical vector field for the CKV in real stereographic coordinates

    triple V(real theta, real phi) {
        pair z = stereographic(theta,phi);
        real x = z.x;
        real y = z.y;
        
        real x2 = x*x;
        real y2 = y*y;
        real r2 = x2 + y2;
        real denom = (1+r2);
        real denom2 = denom*denom;

        real dXdx = 2*(1-x2+y2)/denom2;
        real dXdy = -4*x*y/denom2;
        real dYdx = dXdy;
        real dYdy = 2*(1+x2-y2)/denom2;
        real dZdx = 4*x/denom2;
        real dZdy = 4*y/denom2;

        pair v = Y(x,y);
        real vx = v.x;
        real vy = v.y;
        
        return (dXdx*vx+dXdy*vy,dYdx*vx+dYdy*vy,dZdx*vx+dZdy*vy);
    } // converts vector field in stereographic coordinates to Cartesian

	// next we create a mesh to plot the arrows

    int ntheta = 18;
    int nphi = 36;

    for (int i = 1; i < ntheta; ++i){
        real theta = pi * i / ntheta; // poles are problematic, so we omit them
        for (int j = 0; j < nphi; ++j){
            real phi = 2pi * j / nphi;

            triple p = spherical(theta,phi);
            triple v = V(theta,phi);
            v = 0.15*v;

            draw(p -- (p+v), linewidth(2pt), Arrow3(8,25));
        }
    }
