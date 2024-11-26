function parameters = gen_random_parameter()
    x_t_min = 0.16; x_t_max = 0.4;
    x_t = rand_unif(x_t_min, x_t_max);

    z_t_min = 0.08; z_t_max = 0.16;
    z_t = rand_unif(z_t_min, z_t_max);

    beta_te_min = 0; beta_te_max = 15;
    beta_te = rand_unif(beta_te_min, beta_te_max)*pi/180;

    dz_te_min = 0; dz_te_max = 0;
    dz_te = rand_unif(dz_te_min, dz_te_max);

    rle_min = 0.01; rle_max = 0.05;
    rle = rand_unif(rle_min, rle_max);

    b8_min = 0; b8_max = min(z_t, sqrt(10*rle*x_t)/21);
    b8 = rand_unif(b8_min, b8_max);

    k1 = (3*b8^2)/(2*rle);

    b15_min = min(max(3*x_t-(5/2)*k1, 1-(z_t*b8)/(2*tan(beta_te))), 1); b15_max = 1;
    b15 = rand_unif(b15_min, b15_max);

    x_c_min = 0.2; x_c_max = 0.6;
    x_c = rand_unif(x_c_min, x_c_max);

    z_c_min = 0; z_c_max = 0.05;
    z_c = rand_unif(z_c_min, z_c_max);

    alpha_te_min = 0; alpha_te_max = 15;
    alpha_te = rand_unif(alpha_te_min, alpha_te_max)*pi/180;

    z_te_min = 0; z_te_max = 0;
    z_te = rand_unif(z_te_min, z_te_max);

    k2_min = 0; k2_max = (4*x_c)/7;
    k2 = rand_unif(k2_min, k2_max);

    gamma_le = atan(z_c/k2);

    b0_min = 0; b0_max = z_c/tan(gamma_le);
    b0 = rand_unif(b0_min, b0_max);

    b2_min = b0; b2_max = x_c;
    b2 = rand_unif(b2_min, b2_max);
    
    b17_min = max(1-(5*z_c)/(6*tan(alpha_te)), (-8*k2+13*x_c)/6); b17_max = 1;
    b17 = rand_unif(b17_min, b17_max);

    parameters = [rle, x_t, z_t, x_c, z_c, z_te, dz_te, gamma_le, beta_te, alpha_te, b0, b2, b8, b15, b17];
end