program main
   implicit none
   integer, parameter::N = 256
   integer a(N), b(N), i
   a(:) = 0
   b(:) = 0
   !$acc kernels
   do i = 1, N
      a(i) = a(i) + i
      b(i) = a(i)
   enddo
   !$acc end kernels
   !$acc kernels
   do i = 1, N
      a(i) = a(i) - i
      b(i) = a(i)
   enddo
   !$acc end kernels
   a(:) = 0
   b(:) = 0
   !$acc kernels
   do i = 1, N
      a(i) = a(i) + i
      b(i) = a(i)
   enddo
   do i = 1, N
      a(i) = a(i) - i
      b(i) = a(i)
   enddo
   !$acc end kernels
   print *, "b(N)=", b(N)
end program
