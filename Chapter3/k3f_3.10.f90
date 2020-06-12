program main
   implicit none
   integer, parameter::M = 128, N = 256
   integer i, j, a(M, N), b(M, N), c(M, N)

   do i = 1, M
      do j = 1, N
         a(i, j) = -1
         b(i, j) = i + j
         c(i, j) = i + j
      enddo
   enddo
!$acc kernels
   do j = 1, N
      do i = 1, M
         a(i, j) = b(i, j) + c(i, j)
      enddo
   enddo
!$acc end kernels
   print *, "a(M,N)=", a(M, N)
end program
