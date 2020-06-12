program main
   implicit none
   integer, parameter::L = 64, M = 32, N = 32
   integer, allocatable:: a(:, :, :), b(:, :, :), c(:, :, :)
   integer i, j, k

   allocate (a(L, M, N), b(L, M, N), c(L, M, N))
   do k = 1, M
      do j = 1, N
         do i = 1, L
            a(i, j, k) = -1
            b(i, j, k) = i + j + k
            c(i, j, k) = i + j + k
         enddo
      enddo
   enddo

   !$acc parallel
   !$acc loop
   do k = 1, M
      !OPTIONAL !$acc loop
      do j = 1, N
         !OPTIONAL !$acc loop
         do i = 1, L
            a(i, j, k) = b(i, j, k) + c(i, j, k)
         enddo
      enddo
   enddo
   !$acc end parallel

   print *, "a(L,M,N)", a(L, M, N)
   deallocate (a, b, c)
end program
