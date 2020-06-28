program main
   implicit none
   integer, parameter::N = 1024
   real x(N), coef
   integer i

   do i = 1, N
      x(i) = i
   enddo
   coef = 10
   !acc parallel loop  firstprivate(coef)
   do i = 1, N
      x(i) = coef*x(i)
   enddo
   !acc end parallel loop
   print *, "x(1)=", x(1)
end program
