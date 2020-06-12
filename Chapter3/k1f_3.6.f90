program main
implicit none
integer,parameter::N=1024
integer a(N),b(N),c(N)
integer i

do i=1,N
    a(i)=0
    b(i)=i 
    c(i)=i 
enddo

!$acc kernels
do i=1,N 
    a(i)=b(i)+c(i)
enddo
!$acc end kernels
print*, "a(N)=",a(N)
end program

! main:
    !  13, Generating implicit copyout(a(:)) [if not already present]
        !  Generating implicit copyin(c(:),b(:)) [if not already present]
    !  14, Loop is parallelizable
        !  Generating Tesla code
        !  14, !$acc loop gang, vector(128) ! blockidx%x threadidx%x
