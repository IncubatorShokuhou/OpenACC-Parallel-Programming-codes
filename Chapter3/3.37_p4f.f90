program main
   implicit none
   integer, parameter::M = 32, N = 256
   integer, dimension(M, N):: a, b, c
   integer i, j

   do i = 1, M
      do j = 1, N
         a(i, j) = -1
         b(i, j) = i + j
         c(i, j) = i + j
      enddo
   enddo

   !$acc parallel
   !$acc loop
   do j = 1, N
      !OPTIONAL !$acc loop
      do i = 1, N
         a(i, j) = b(i, j) + c(i, j)
      enddo
   enddo
   !$acc end parallel

   print *, "a(M,N)", a(M, N)
end program
