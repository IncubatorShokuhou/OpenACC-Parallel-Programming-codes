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
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
   do i = 1, N/2
      b(i) = 2*a(i)
   enddo
!$acc end kernels
   print *, "b(N/2)=", b(N/2)
end program