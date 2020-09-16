program main
    implicit none
    integer, parameter::N =128
    integer a(N)
    !$acc declare create(a)
    integer i
    
    a(1) = -10  !在host上更改a的值
    a(2) = -20
    !$acc kernels loop   !没有更新到device,device上a的值仍然是0
    do i = 1,N
        a(i) =a(i) +i
    enddo
    !$acc update host(a(1:1))   !更新到host
    print*,"a(1)=", a(1)
end program