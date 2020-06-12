program main
   implicit none
   integer, parameter::N = 100
   integer i
   logical a(N), ired   !将原本数值改为布尔值，从而更清晰看出结果
   do i = 1, N
        if(MOD(i,2) .eq. 0)then
             a(i) = .false.
           ! a(i) = .true.   !如果所有a都为.true.则最后输出结果为"T"
        else
            a(i) = .true.
        end if
   enddo
   ired = .true.
   !$acc parallel
   !$acc loop reduction(.and.:ired)
   do i = 1, N
      ired = ired .and. a(i)
   enddo
   !$acc end loop
   !$acc end parallel
   print *, "ired=", ired
end program