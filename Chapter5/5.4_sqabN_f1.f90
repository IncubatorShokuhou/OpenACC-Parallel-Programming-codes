program main
    implicit none
    real,external::sqab
    integer,parameter::N=100
    integer::idx
    real  x(N)

    do idx = 1,N 
        x(idx) = sqab(idx*1.0)
    enddo

    print*,"x(3)=",x(3)
end program main