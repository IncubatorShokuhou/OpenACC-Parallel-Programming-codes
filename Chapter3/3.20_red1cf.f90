program main
   implicit none
   integer, parameter::N = 100
   integer i, ired, a(N)
   do i = 1, N
      a(i) = i
   enddo
   ired = 0
   !$acc parallel
   !$acc loop reduction(+:ired)
   do i = 1, N
      ired = ired + a(i)
   enddo
   do i = 1, N
      a(i) = a(i) + ired
   enddo
   !$acc end loop
   !$acc end parallel
   print *, "ired=", ired
   print *, "a(1)=", a(1)
end program
