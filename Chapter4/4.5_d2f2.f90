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
!$acc data create(a)
!$acc kernels present(a)
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
!$acc end kernels
!$acc end data
   print *, "a(N)=", a(N)
end program
