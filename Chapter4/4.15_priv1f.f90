program main
   implicit none
   integer, parameter::N = 1024
   real x(N), sinx(N)
   integer i
   real tmp

   do i = 1, N
      x(i) = (0.1*i)/N
   enddo
   !$acc kernels loop private(tmp)  !相当于为每个循环，分配了一个单独的tmp,使其不互相影响
   do i = 1, N
      sinx(i) = x(i)
      tmp = x(i)*x(i)*x(i)
      sinx(i) = sinx(i) - tmp/6
      tmp = tmp*x(i)*x(i)
      sinx(i) = sinx(i) + tmp/120
   enddo
   !$acc end kernels loop

   print *, "x(1) =", x(1), "sinx(1) =", sinx(1)
end program
