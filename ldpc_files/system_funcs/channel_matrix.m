function H=channel_matrix(tx,rx,fadingtype,factor)

    switch fadingtype
        case 'Rayleigh'
            H=randn([rx tx])+randn([rx tx])*1i;
        case 'Rician'
            H=channel_matrix(tx,rx,'Rayleigh');
            H=sqrt(factor/(1+factor))*ones(rx,tx)+sqrt(1/(1+factor))*H;
    end
end
    