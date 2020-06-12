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
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
   !$acc end parallel

   !$acc parallel   !无independent,会有依赖，串行
   do i = 2, N
      b(i) = b(i - 1)
   enddo
   !$acc end parallel
   print *, "a(N)=", a(N)
end program
