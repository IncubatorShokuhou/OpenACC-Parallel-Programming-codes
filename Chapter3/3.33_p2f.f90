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
   !$acc loop    !有independent,无视依赖，并行
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
   !$acc end parallel

   !$acc parallel   
   !$acc loop    !有independent,无视依赖，并行
   do i = 2, N
      b(i) = b(i - 1)
   enddo
   !$acc end parallel
   print *, "a(N-1)=", a(N-1)
   print *, "b=", b(20:30)
   !no acc:  1,1,....1
   !acc: 19,20,21....29
end program
