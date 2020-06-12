program main
   implicit none
   integer, parameter::N = 20  !源代码为100，若ired初始值为1，则超过integer(4)范围，会显示0
   integer(kind=8) i, ired, a(N) !如果ired为integer(4),则结果会显示-2102132736
   do i = 1, N 
      a(i) = i
   enddo
!    print*,a
   ired = 1  !原代码ired=0,阶乘看不出效果，改为1
   !$acc parallel
   !$acc loop reduction(*:ired)
   do i = 1, N
      ired = ired * a(i)
   enddo
   !$acc end loop
   !$acc end parallel
   print *, "ired=", ired
end program