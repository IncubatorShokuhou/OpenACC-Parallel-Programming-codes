program main
   implicit none
   integer, parameter::N = 100
   integer i, ired, a(N)
   do i = 1, N
      a(i) = i
   enddo
   ired = 0
   !$acc parallel
   !$acc loop reduction(max:ired)
   do i = 1, N
      ired = max(ired,a(i))
   enddo
   !$acc end loop
   !$acc end parallel
   print *, "ired=", ired
end program