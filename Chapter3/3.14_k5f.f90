program main
   implicit none
   integer, parameter::N = 1024
   integer a(N), b(N), c(N)
   integer i

   do i = 1, N
      a(i) = 0
      b(i) = i
      c(i) = i
   enddo

!$acc kernels
!$acc loop
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
!$acc loop 
!!$acc loop independent
   do i = 2, N
      b(i) = b(i - 1)
   enddo
!$acc end kernels
   print *, "b(2)=", b(2)
   ! print*,b(100:110)
end program
