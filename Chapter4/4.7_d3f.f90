program main
   implicit none
   integer, parameter::N = 256
   integer a(N), b(N)
   integer i

   do i = 1, N
      a(i) = i
      b(i) = i
   enddo
   !$acc kernels
   do i = 1, N
      a(i) = a(i) + b(i)
   enddo
   !$acc end kernels
   print *, "a(N)=", a(N)
end program
!编译器反馈：
!11, Generating implicit copy(a(:)) [if not already present]
!   Generating implicit copyin(b(:)) [if not already present]
!b 用到了，但是没有修改，所以不需要从设备再拷贝回主机