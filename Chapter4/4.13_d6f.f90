program main
   implicit none
   integer, parameter::N = 256
   integer a(N), b(N), c(N)
   integer i

   do i = 1, N
      a(i) = 0
      b(i) = i
   enddo
   !$acc kernels create(a) copyout(b(N:N)) !只把b(N:N)这一个点的值拷贝回主机
   do i = 2, N
      a(i) = b(i - 1) + b(i)
   enddo
   do i = 2, N
      b(i) = a(i)
   enddo
   !$acc end kernels
   print *, "b(N)=", b(N)
end program
