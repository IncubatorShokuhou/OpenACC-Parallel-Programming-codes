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
   !$acc parallel
   !$acc loop
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
   !$acc end parallel

   !$acc parallel
   !$acc loop
   do i = 2, N
      b(i) = 2*a(i)
   enddo
   !$acc end parallel
   print *, "b(N/2)=", b(N/2)
end program
