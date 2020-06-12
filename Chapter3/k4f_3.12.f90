program main
   implicit none
   integer, parameter::L = 32, M = 32, N = 32
   integer i, j, k
   integer, allocatable::   a(:, :, :), b(:, :, :), c(:, :, :)

   allocate (a(L, M, N), b(L, M, N), c(L, M, N))
   do k = 1, N
      do j = 1, M
         do i = 1, L
            a(i, j, k) = -1
            b(i, j, k) = i + j + k
            c(i, j, k) = i + j + k
         enddo
      enddo
   enddo
!$acc kernels
   do k = 1, N
      do j = 1, M
         do i = 1, L
            a(i, j, k) = b(i, j, k) + c(i, j, k)
         enddo
      enddo
   enddo
!$acc end kernels
   print *, "a(L,M,N)=", a(L, M, N)
   deallocate (a, b, c)
end program
