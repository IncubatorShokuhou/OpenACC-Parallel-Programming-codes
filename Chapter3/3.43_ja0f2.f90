program main
   implicit none
   real, parameter::widthy = 2.0, heightx = 1.0
   real hx, hy
   integer, parameter::mx = 8191, ny = 1023
   real(kind=4), allocatable::u0(:, :), u1(:, :)
   integer maxiter, iter, ix, jy
   real(kind=4) uerr, errtol
   real fij, c1, c2, hx2, hy2
   real tstart, tend
   real, external::uval

   maxiter = 100
   errtol = 0.0
   hy = widthy/ny
   hx = heightx/mx

   allocate (u0(0:mx, 0:ny), u1(0:mx, 0:ny))  !保存二维格点的旧值和新值

   !Initalize the left/right boundary of u0/u1
   do ix = 0, mx
      u0(ix, 0) = uval(ix*hx, 0.0)
      u0(ix, ny) = uval(ix*hx, ny*hy)
   enddo
   u1(0:mx, 0) = u0(0:mx, 0)
   u1(0:mx, ny) = u0(0:mx, ny)

   !Initalize the upper/lower boundary of u0/u1
   do jy = 0, ny
      u0(0, jy) = uval(0.0, jy*hy)
      u0(mx, jy) = uval(mx*hx, jy*hy)
   enddo
   u1(0, 0:ny) = u0(0, 0:ny)
   u1(mx, 0:ny) = u0(mx, 0:ny)

   !Initalize the interior point of u0
   u0(1:mx - 1, 1:ny - 1) = 0.0

   fij = -4.
   c1 = hx*hx*hy*hy
   c2 = 1./(2.*(hx*hx + hy*hy))
   hx2 = hx*hx
   hy2 = hy*hy
   call cpu_time(tstart)
   ! main iterationsl
   do iter = 1, maxiter, 2
      do jy = 1, ny - 1
         do ix = 1, mx - 1
            u1(ix, jy) = (fij*c1 + hy2*(u0(ix - 1, jy) + u0(ix + 1, jy)) + hx2*(u0(ix, jy - 1) + u0(ix, jy + 1)))*c2
         enddo
      enddo
    !   uerr = 0.
      do jy = 1, ny - 1
         do ix = 1, mx - 1
            u0(ix, jy) = (fij*c1 + hy2*(u1(ix - 1, jy) + u1(ix + 1, jy)) + hx2*(u1(ix, jy - 1) + u1(ix, jy + 1)))*c2
            ! uerr = max(uerr,abs(u0(ix, jy)-u1(ix, jy)))
         enddo
      enddo
    !   print *, "iter=", iter, "uerr=", uerr,"errtol=",errtol
    !   if (uerr .lt. errtol) then
        !  print*, "uerr =",uerr,"errtol =",errtol," exit"
        !  exit
    !   end if
   enddo
   call cpu_time(tend)
   print *, "ElapsedTime =", tend - tstart, " seconds"
   deallocate (u0, u1)
end program
!========================
function uval(x, y)
   real, intent(in)::x, y
   uval = x*x + y*y
end function
