program main
   implicit none
   integer, parameter::N = 1024
   real x(N), sinx(N)
   integer i
   real tmp(2)

   do i = 1, N
      x(i) = (0.1*i)/N
   enddo
   !$acc kernels loop private(tmp)
   do i = 1, N
      tmp(1) = x(i)*x(i)*x(i)
      tmp(2) = tmp(1)*x(i)*x(i)
      sinx(i) = x(i) - tmp(1)/6 + tmp(2)/120
   enddo
   !$acc end kernels loop

   print *, "x(1) =", x(1), "sinx(1) =", sinx(1)
end program
! main: 如果不注释private语句
! 11, Generating implicit copyin(x(:)) [if not already present]
! Generating implicit copyout(sinx(:)) [if not already present]
! 12, Loop is parallelizable
! Generating Tesla code
! 12, !$acc loop gang, vector(128) ! blockidx%x threadidx%x
! 12, Local memory used for tmp

! main:如果注释了private语句
! 11, Generating implicit copyout(sinx(:),tmp(:)) [if not already present] !此处tmp被当成了共享变量
! Generating implicit copyin(x(:)) [if not already present]
! 12, Complex loop carried dependence of tmp prevents parallelization
! Parallelization would require privatization of array tmp(:)  !点明若要并行则需要将tmp私有化
! Accelerator serial kernel generated   ！无法并行，只可以serial
! Generating Tesla code
! 12, !$acc loop seq
! 12, Complex loop carried dependence of tmp prevents parallelization
! Parallelization would require privatization of array tmp(:)