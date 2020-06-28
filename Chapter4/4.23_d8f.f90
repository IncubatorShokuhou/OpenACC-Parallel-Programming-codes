program main
    implicit none
    integer, parameter::N =256
    integer a(N), b(N),i
    a(:)=0
    b(:)=0 
    !$acc