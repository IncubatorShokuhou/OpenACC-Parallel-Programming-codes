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

!$acc kernels present(a)    !这样执行编译会有错误。编译时，会自动添加b和c的copyin，而用了present后，
   !告诉了编译器a已经在设备内存里了，而实际上a并不在。
   !错误语句：FATAL ERROR: data in PRESENT clause was not found on device 1: name=a host:0x6045a0
   do i = 1, N
      a(i) = b(i) + c(i)
   enddo
!$acc end kernels
   print *, "a(N)=", a(N)
end program
